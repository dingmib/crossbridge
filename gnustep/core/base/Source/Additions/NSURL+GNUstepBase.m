/* Implementation of extension methods to base additions

   Copyright (C) 2010 Free Software Foundation, Inc.

   Written by:  Richard Frith-Macdonald <rfm@gnu.org>

   This file is part of the GNUstep Base Library.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02111 USA.

*/

#import "common.h"
#import "Foundation/NSValue.h"
#import "GNUstepBase/NSURL+GNUstepBase.h"

@implementation NSURL (GNUstepBaseAdditions)

- (id) initWithScheme: (NSString*)scheme
		 user: (NSString*)user
	     password: (NSString*)password
		 host: (NSString*)host
		 port: (NSNumber*)port
	     fullPath: (NSString*)fullPath
      parameterString: (NSString*)parameterString
		query: (NSString*)query
	     fragment: (NSString*)fragment
{
  NSMutableString	*urlString;
  NSString		*s;

  urlString = [scheme mutableCopy];
  [urlString appendString: @"://"];
  if ([user length] > 0 || [password length] > 0)
    {
      if (nil == (s = user)) s = @"";
      [urlString appendString:
	[s stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
      [urlString appendString: @":"];
      if (nil == (s = password)) s = @"";
      [urlString appendString:
	[s stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
      [urlString appendString: @"@"];
    }
  if ([host length] > 0)
    {
      [urlString appendString:
	[host stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    }
  if ([port intValue] > 0)
    {
      [urlString appendString: @":"];
      [urlString appendFormat: @"%u", [port intValue]];
    }

  if (nil == (s = fullPath)) s = @"";
  if ([s hasPrefix: @"/"] == NO)
    {
      [urlString appendString: @"/"];
    }
  [urlString appendString:
    [s stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];

  if ([parameterString length] > 0)
    {
      [urlString appendString: @";"];
      [urlString appendString: parameterString];
    }

  if ([query length] > 0)
    {
      [urlString appendString: @"?"];
      [urlString appendString: query];
    }

  if ([fragment length] > 0)
    {
      [urlString appendString: @"#"];
      [urlString appendString: fragment];
    }

  self = [self initWithString: urlString];
  [urlString release];
  return self;
}
@end

#ifndef	GNUSTEP

#import	<CFURL.h>

@implementation NSURL (GNUstepBase)

/* For efficiency this is built in to the main library.
 */
- (NSString*) fullPath
{
  NSRange	r;
  NSString	*s;

  s = [self absoluteString];
  if ((r = [s rangeOfString: @";"]).length > 0)
    {
      s = [s substringToIndex: r.location];
    }
  else if ((r = [s rangeOfString: @"?"]).length > 0)
    {
      s = [s substringToIndex: r.location];
    }
  r = [s rangeOfString: @"//"];
  s = [s substringFromIndex: NSMaxRange(r)];
  r = [s rangeOfString: @"/"];
  s = [s substringFromIndex: r.location];
  return s;
}

/* For efficiency this is built in to the main library.
 */
- (NSString*) pathWithEscapes
{
  return CFURLCopyPath(self);
}

@end
#endif

