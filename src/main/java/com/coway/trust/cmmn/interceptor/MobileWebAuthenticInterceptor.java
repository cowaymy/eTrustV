package com.coway.trust.cmmn.interceptor;

import java.io.BufferedReader;
import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.util.Enumeration;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.WebContentInterceptor;

import com.coway.trust.biz.common.CommonService;
import com.coway.trust.cmmn.exception.AuthException;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;

public class MobileWebAuthenticInterceptor
  extends WebContentInterceptor {
  private static final Logger LOGGER = LoggerFactory.getLogger( MobileWebAuthenticInterceptor.class );

  @Autowired
  private SessionHandler sessionHandler;

  @Autowired
  private CommonService commonService;

  @Override
  public boolean preHandle( HttpServletRequest request, HttpServletResponse response, Object handler ) throws ServletException {
    LOGGER.debug( "[Mobile] preHandle :: URI :: " + request.getRequestURI() );
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    if ( sessionVO != null && sessionVO.getUserId() > 0 ) {
      checkAuthorized();
    } else {
      // WRITE LOGS FOR HEADER, PARAMS AND ATTRIBUTE
      // logRequestHeaders( request );
      // logRequestParameters( request );
      // logRequestAttributes( request );

      if ( !validateApiAccess( request ) ) {
        LOGGER.debug( "[preHandle] AuthenticInterceptor > API ACCESS VARIFICATION > AuthException [ URI : {}{}]", request.getContextPath(), request.getRequestURI() );
        throw new AuthException( HttpStatus.UNAUTHORIZED, HttpStatus.UNAUTHORIZED.getReasonPhrase() );
      }
    }
    return true;
  }

  /**
   * 권한 체크.
   */
  private void checkAuthorized() {
    LOGGER.debug( "권한체크" );
  }

  @Override
  public void postHandle( HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView ) throws Exception {
    LOGGER.debug( "[Mobile] postHandle :: URI :: " + request.getRequestURI() );
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    if ( sessionVO == null || sessionVO.getUserId() == 0 ) {
      LOGGER.debug( "세션체크" );
      // WRITE LOGS FOR HEADER, PARAMS AND ATTRIBUTE
      // logRequestHeaders( request );
      // logRequestParameters( request );
      // logRequestAttributes( request );

      if ( !validateApiAccess( request ) ) {
        LOGGER.debug( "[postHandle] AuthenticInterceptor > API ACCESS VARIFICATION > AuthException [ URI : {}{}]", request.getContextPath(), request.getRequestURI() );
        throw new AuthException( HttpStatus.UNAUTHORIZED, HttpStatus.UNAUTHORIZED.getReasonPhrase() );
      }
    }
  }

  private boolean validateApiAccess( HttpServletRequest request ) {
    @SuppressWarnings("unchecked")
    Map<String, String[]> parameterMap = request.getParameterMap();
    if ( parameterMap.size() > 0 ) {
      if (parameterMap.get( "sKey" ) != null && parameterMap.get( "sUid" ) != null) {
        // REQUEST PARAMS
        String[] sKey = parameterMap.get( "sKey" );
        String[] sUid = parameterMap.get( "sUid" );
        // GET ACTUAL TOKEN
        String a_sKey;
        try {
          a_sKey = CommonUtils.nvl( commonService.getApisKey( CommonUtils.nvl( sUid[0] ) ) );
          if ( a_sKey.equals( CommonUtils.nvl( sKey[0] ) ) ) {
            return true;
          } else {
            return false;
          }
        } catch ( NoSuchAlgorithmException e ) {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  /* FOR LOGS USED */
  public void logRequestHeaders( HttpServletRequest request ) {
    Enumeration<String> headerNames = request.getHeaderNames();
    while ( headerNames.hasMoreElements() ) {
      String headerName = headerNames.nextElement();
      String headerValue = request.getHeader( headerName );
      LOGGER.debug( "Header: " + headerName + " = " + headerValue );
    }
  }

  public void logRequestParameters( HttpServletRequest request ) {
    Map<String, String[]> parameterMap = request.getParameterMap();
    for ( String paramName : parameterMap.keySet() ) {
      String[] paramValues = parameterMap.get( paramName );
      LOGGER.debug( "Parameter: " + paramName + " = " + String.join( ", ", paramValues ) );
    }
  }

  public void logRequestAttributes( HttpServletRequest request ) {
    Enumeration<String> attributeNames = request.getAttributeNames();
    while ( attributeNames.hasMoreElements() ) {
      String attributeName = attributeNames.nextElement();
      Object attributeValue = request.getAttribute( attributeName );
      LOGGER.debug( "Attribute: " + attributeName + " = " + attributeValue );
    }
  }

  public String getRequestBody( HttpServletRequest request )
    throws IOException {
    StringBuilder stringBuilder = new StringBuilder();
    BufferedReader bufferedReader = request.getReader();
    String line;
    while ( ( line = bufferedReader.readLine() ) != null ) {
      stringBuilder.append( line );
    }
    return stringBuilder.toString();
  }
}
