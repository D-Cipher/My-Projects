#import <Foundation/Foundation.h>
#import "USAdditions.h"
#import <libxml/tree.h>
#import "USGlobals.h"
@class GroupServiceService_getGroupRequest;
@class GroupServiceService_getGroupResponse;
@class GroupServiceService_respondGroup;
@class GroupServiceService_getCaseByGroupIdRequest;
@class GroupServiceService_getCaseByGroupIdResponse;
@class GroupServiceService_respondCase;
@class GroupServiceService_respondCategory;
@class GroupServiceService_respondAnswerChoices;
@interface GroupServiceService_getGroupRequest : NSObject {
	
/* elements */
	NSString * searchString;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (GroupServiceService_getGroupRequest *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * searchString;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface GroupServiceService_respondGroup : NSObject {
	
/* elements */
	NSNumber * id_;
	NSString * groupName;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (GroupServiceService_respondGroup *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSNumber * id_;
@property (retain) NSString * groupName;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface GroupServiceService_getGroupResponse : NSObject {
	
/* elements */
	NSMutableArray *respondGroup;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (GroupServiceService_getGroupResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
- (void)addRespondGroup:(GroupServiceService_respondGroup *)toAdd;
@property (readonly) NSMutableArray * respondGroup;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface GroupServiceService_getCaseByGroupIdRequest : NSObject {
	
/* elements */
	NSNumber * groupId;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (GroupServiceService_getCaseByGroupIdRequest *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSNumber * groupId;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface GroupServiceService_respondAnswerChoices : NSObject {
	
/* elements */
	NSNumber * id_;
	NSString * choicesText;
	USBoolean * correctAnswer;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (GroupServiceService_respondAnswerChoices *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSNumber * id_;
@property (retain) NSString * choicesText;
@property (retain) USBoolean * correctAnswer;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface GroupServiceService_respondCategory : NSObject {
	
/* elements */
	NSNumber * id_;
	NSString * type;
	NSString * title;
	NSString * text;
	NSNumber * order;
	NSString * explanation;
	NSMutableArray *respondAnswerChoices;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (GroupServiceService_respondCategory *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSNumber * id_;
@property (retain) NSString * type;
@property (retain) NSString * title;
@property (retain) NSString * text;
@property (retain) NSNumber * order;
@property (retain) NSString * explanation;
- (void)addRespondAnswerChoices:(GroupServiceService_respondAnswerChoices *)toAdd;
@property (readonly) NSMutableArray * respondAnswerChoices;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface GroupServiceService_respondCase : NSObject {
	
/* elements */
	NSNumber * id_;
	NSString * caseName;
	NSMutableArray *respondCategory;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (GroupServiceService_respondCase *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSNumber * id_;
@property (retain) NSString * caseName;
- (void)addRespondCategory:(GroupServiceService_respondCategory *)toAdd;
@property (readonly) NSMutableArray * respondCategory;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface GroupServiceService_getCaseByGroupIdResponse : NSObject {
	
/* elements */
	NSMutableArray *respondCase;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (GroupServiceService_getCaseByGroupIdResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
- (void)addRespondCase:(GroupServiceService_respondCase *)toAdd;
@property (readonly) NSMutableArray * respondCase;
/* attributes */
- (NSDictionary *)attributes;
@end
/* Cookies handling provided by http://en.wikibooks.org/wiki/Programming:WebObjects/Web_Services/Web_Service_Provider */
#import <libxml/parser.h>
#import "xs.h"
#import "GroupServiceService.h"
@class GroupServiceSoap11Binding;
@interface GroupServiceService : NSObject {
	
}
+ (GroupServiceSoap11Binding *)GroupServiceSoap11Binding;
@end
@class GroupServiceSoap11BindingResponse;
@class GroupServiceSoap11BindingOperation;
@protocol GroupServiceSoap11BindingResponseDelegate <NSObject>
- (void) operation:(GroupServiceSoap11BindingOperation *)operation completedWithResponse:(GroupServiceSoap11BindingResponse *)response;
@end
@interface GroupServiceSoap11Binding : NSObject <GroupServiceSoap11BindingResponseDelegate> {
	NSURL *address;
	NSTimeInterval defaultTimeout;
	NSMutableArray *cookies;
	BOOL logXMLInOut;
	BOOL synchronousOperationComplete;
	NSString *authUsername;
	NSString *authPassword;
}
@property (copy) NSURL *address;
@property (assign) BOOL logXMLInOut;
@property (assign) NSTimeInterval defaultTimeout;
@property (nonatomic, retain) NSMutableArray *cookies;
@property (nonatomic, retain) NSString *authUsername;
@property (nonatomic, retain) NSString *authPassword;
- (id)initWithAddress:(NSString *)anAddress;
- (void)sendHTTPCallUsingBody:(NSString *)body soapAction:(NSString *)soapAction forOperation:(GroupServiceSoap11BindingOperation *)operation;
- (void)addCookie:(NSHTTPCookie *)toAdd;
- (GroupServiceSoap11BindingResponse *)getCaseByGroupIdUsingGetCaseByGroupIdRequest:(GroupServiceService_getCaseByGroupIdRequest *)aGetCaseByGroupIdRequest ;
- (void)getCaseByGroupIdAsyncUsingGetCaseByGroupIdRequest:(GroupServiceService_getCaseByGroupIdRequest *)aGetCaseByGroupIdRequest  delegate:(id<GroupServiceSoap11BindingResponseDelegate>)responseDelegate;
- (GroupServiceSoap11BindingResponse *)getGroupUsingGetGroupRequest:(GroupServiceService_getGroupRequest *)aGetGroupRequest ;
- (void)getGroupAsyncUsingGetGroupRequest:(GroupServiceService_getGroupRequest *)aGetGroupRequest  delegate:(id<GroupServiceSoap11BindingResponseDelegate>)responseDelegate;
@end
@interface GroupServiceSoap11BindingOperation : NSOperation {
	GroupServiceSoap11Binding *binding;
	GroupServiceSoap11BindingResponse *response;
	id<GroupServiceSoap11BindingResponseDelegate> delegate;
	NSMutableData *responseData;
	NSURLConnection *urlConnection;
}
@property (retain) GroupServiceSoap11Binding *binding;
@property (readonly) GroupServiceSoap11BindingResponse *response;
@property (nonatomic, assign) id<GroupServiceSoap11BindingResponseDelegate> delegate;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSURLConnection *urlConnection;
- (id)initWithBinding:(GroupServiceSoap11Binding *)aBinding delegate:(id<GroupServiceSoap11BindingResponseDelegate>)aDelegate;
@end
@interface GroupServiceSoap11Binding_getCaseByGroupId : GroupServiceSoap11BindingOperation {
	GroupServiceService_getCaseByGroupIdRequest * getCaseByGroupIdRequest;
}
@property (retain) GroupServiceService_getCaseByGroupIdRequest * getCaseByGroupIdRequest;
- (id)initWithBinding:(GroupServiceSoap11Binding *)aBinding delegate:(id<GroupServiceSoap11BindingResponseDelegate>)aDelegate
	getCaseByGroupIdRequest:(GroupServiceService_getCaseByGroupIdRequest *)aGetCaseByGroupIdRequest
;
@end
@interface GroupServiceSoap11Binding_getGroup : GroupServiceSoap11BindingOperation {
	GroupServiceService_getGroupRequest * getGroupRequest;
}
@property (retain) GroupServiceService_getGroupRequest * getGroupRequest;
- (id)initWithBinding:(GroupServiceSoap11Binding *)aBinding delegate:(id<GroupServiceSoap11BindingResponseDelegate>)aDelegate
	getGroupRequest:(GroupServiceService_getGroupRequest *)aGetGroupRequest
;
@end
@interface GroupServiceSoap11Binding_envelope : NSObject {
}
+ (GroupServiceSoap11Binding_envelope *)sharedInstance;
- (NSString *)serializedFormUsingHeaderElements:(NSDictionary *)headerElements bodyElements:(NSDictionary *)bodyElements;
@end
@interface GroupServiceSoap11BindingResponse : NSObject {
	NSArray *headers;
	NSArray *bodyParts;
	NSError *error;
}
@property (retain) NSArray *headers;
@property (retain) NSArray *bodyParts;
@property (retain) NSError *error;
@end
