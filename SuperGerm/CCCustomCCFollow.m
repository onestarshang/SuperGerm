//
//  CCCustomFollow.m
//  Cocos2D-Scrolling
//
//  Copyright Steffen Itterheim 2012. Distributed under MIT License.
//

#import "CCCustomCCFollow.h"


@implementation CCCustomCCFollow

+(id) actionWithTarget:(CCNode *) fNode worldBoundary:(CGRect)rect worldScale:(float)s
{
	return [[[self alloc] initWithTarget:fNode worldBoundary:rect worldScale:s] autorelease];
}


-(id) initWithTarget:(CCNode *)fNode worldBoundary:(CGRect)rect worldScale:(float)s
{
	if( (self=[super init]) ) {
        
		_followedNode = [fNode retain];
		_boundarySet = TRUE;
		_boundaryFullyCovered = FALSE;
        
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		_fullScreenSize = CGPointMake(winSize.width/s, winSize.height/s);
		_halfScreenSize = ccpMult(_fullScreenSize, .5f);
        
		_leftBoundary = -((rect.origin.x+rect.size.width) - _fullScreenSize.x);
		_rightBoundary = -rect.origin.x ;
		_topBoundary = -rect.origin.y;
		_bottomBoundary = -((rect.origin.y+rect.size.height) - _fullScreenSize.y);
        
		if(_rightBoundary < _leftBoundary)
		{
			// screen width is larger than world's boundary width
			//set both in the middle of the world
			_rightBoundary = _leftBoundary = (_leftBoundary + _rightBoundary) / 2;
		}
		if(_topBoundary < _bottomBoundary)
		{
			// screen width is larger than world's boundary width
			//set both in the middle of the world
			_topBoundary = _bottomBoundary = (_topBoundary + _bottomBoundary) / 2;
		}
        
		if( (_topBoundary == _bottomBoundary) && (_leftBoundary == _rightBoundary) )
			_boundaryFullyCovered = TRUE;
	}
    
	return self;
}


-(void) step:(ccTime) dt
{
#define CLAMP(x,y,z) MIN(MAX(x,y),z)
    
    CGPoint pos;
    if(_boundarySet)
    {
        // whole map fits inside a single screen, no need to modify the position - unless map boundaries are increased
        if(_boundaryFullyCovered)
            return;
        
        CCNode *n = (CCNode*)_target;
        float s = n.scale;
        CGPoint tempPos = ccpSub( _halfScreenSize, _followedNode.position);
        tempPos.x *= s;
        tempPos.y *= s;
        pos = ccp(CLAMP(tempPos.x,_leftBoundary,_rightBoundary), CLAMP(tempPos.y,_bottomBoundary,_topBoundary));
    }
    else {
        CCNode *n = (CCNode*)_target;
        float s = n.scale;
        pos = ccpSub( _halfScreenSize, _followedNode.position );
        pos.x *= s;
        pos.y *= s;
        
        //pos = ccpSub( halfScreenSize, followedNode_.position );
    }
    
    CGPoint moveVect;
    
    CGPoint oldPos = [_target position];
    double dist = ccpDistance(pos, oldPos);
    if (dist > 1){
        moveVect = ccpMult(ccpSub(pos,oldPos),1); //0.05 is the smooth constant.
        oldPos = ccpAdd(oldPos, moveVect);
        [_target setPosition:oldPos];
    }
    
#undef CLAMP
}

// unless you need to modify the world boundaries, the only method you need to override is step:
//-(void) step:(ccTime) dt
//{
//	// If the user has restricted scrolling to a specific size, the boundary is set. Otherwise scrolling is not limited.
//	if (_boundarySet)
//	{
//		// If the scrolling world is smaller than the screen size, scrolling is disabled.
//		if (_boundaryFullyCovered)
//		{
//			return;
//		}
//        
//		// Scrolling is limited, so after moving the target (the layer containing the followed node) the position is
//		// clamped to the boundaries. These boundaries prevent the layer from scrolling too close to a border, because
//		// this might reveal the area outside of the world.
//        
//		// The targetPos coordinate values become more negative the more the followed node moved to the right and up.
//		// This is because the layer is moved in the opposite direction of where the followed node is heading.
//		CGPoint targetPos = ccpSub(_halfScreenSize, _followedNode.position);
//        
//		// ensure that temp pos coordinates are within left/right and bottom/top boundary coordinates
//		targetPos.x = clampf(targetPos.x, _leftBoundary, _rightBoundary);
//		targetPos.y = clampf(targetPos.y, _bottomBoundary, _topBoundary);
//        
//        
//		// Modification: only start scrolling if targetPos and currentPos are far apart.
//        
//		// initialize currentPos once
//		if (isCurrentPosValid == NO)
//		{
//			isCurrentPosValid = YES;
//			currentPos = targetPos;
//		}
//        
//		// if current & target pos are this many points away, scrolling will start following the followed node
//		const float kMaxDistanceFromCenter = 120.0f;
//        
//		float distanceFromCurrentToTargetPos = ccpLength(ccpSub(targetPos, currentPos));
//		if (distanceFromCurrentToTargetPos > kMaxDistanceFromCenter)
//		{
//			// get the delta movement to the last target position
//			CGPoint deltaPos = ccpSub(targetPos, previousTargetPos);
//			// add the delta to currentPos to track followed node at the distance threshold
//			currentPos = ccpAdd(currentPos, deltaPos);
//            
//			// Note: this code requires additional steps to ensure the scrolling correctly stops at the world boundary.
//			// These steps are not included. This example is to show how you can customize the scrolling behavior by subclassing CCFollow.
//            
//			//NSLog(@"currentPos: %.1f, %.1f", currentPos.x, currentPos.y);
//			[_target setPosition:currentPos];
//		}
//        
//		previousTargetPos = targetPos;
//	}
//	else
//	{
//		// Scrolling is not limited, simply move the target (the layer containing the followed node) so that the
//		// followed node is centered on the screen.
//		[_target setPosition:ccpSub(_halfScreenSize, _followedNode.position)];
//	}
//}



#pragma mark For Reference: CCFollow original methods (the interesting ones)

/*
 -(id) initWithTarget:(CCNode *)fNode
 {
 if( (self=[super init]) ) {
 
 followedNode_ = [fNode retain];
 boundarySet = FALSE;
 boundaryFullyCovered = FALSE;
 
 CGSize s = [[CCDirector sharedDirector] winSize];
 fullScreenSize = CGPointMake(s.width, s.height);
 halfScreenSize = ccpMult(fullScreenSize, .5f);
 }
 
 return self;
 }
 
 -(id) initWithTarget:(CCNode *)fNode worldBoundary:(CGRect)rect
 {
 if( (self=[super init]) ) {
 
 followedNode_ = [fNode retain];
 boundarySet = TRUE;
 boundaryFullyCovered = FALSE;
 
 CGSize winSize = [[CCDirector sharedDirector] winSize];
 fullScreenSize = CGPointMake(winSize.width, winSize.height);
 halfScreenSize = ccpMult(fullScreenSize, .5f);
 
 leftBoundary = -((rect.origin.x+rect.size.width) - fullScreenSize.x);
 rightBoundary = -rect.origin.x ;
 topBoundary = -rect.origin.y;
 bottomBoundary = -((rect.origin.y+rect.size.height) - fullScreenSize.y);
 
 if(rightBoundary < leftBoundary)
 {
 // screen width is larger than world's boundary width
 //set both in the middle of the world
 rightBoundary = leftBoundary = (leftBoundary + rightBoundary) / 2;
 }
 if(topBoundary < bottomBoundary)
 {
 // screen width is larger than world's boundary width
 //set both in the middle of the world
 topBoundary = bottomBoundary = (topBoundary + bottomBoundary) / 2;
 }
 
 if( (topBoundary == bottomBoundary) && (leftBoundary == rightBoundary) )
 boundaryFullyCovered = TRUE;
 }
 
 return self;
 }
 
 -(void) step:(ccTime) dt
 {
 if(boundarySet)
 {
 // whole map fits inside a single screen, no need to modify the position - unless map boundaries are increased
 if(boundaryFullyCovered)
 return;
 
 CGPoint tempPos = ccpSub( halfScreenSize, followedNode_.position);
 [target_ setPosition:ccp(clampf(tempPos.x,leftBoundary,rightBoundary), clampf(tempPos.y,bottomBoundary,topBoundary))];
 }
 else
 [target_ setPosition:ccpSub( halfScreenSize, followedNode_.position )];
 }
 */

@end