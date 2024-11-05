package com.coway.trust.cmmn.interceptor;

import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.HashMap;
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

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AccessMonitoringService;
import com.coway.trust.biz.common.MenuService;
import com.coway.trust.biz.login.LoginService;
import com.coway.trust.cmmn.exception.AuthException;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public class AuthenticInterceptor
  extends WebContentInterceptor {
  private static final Logger LOGGER = LoggerFactory.getLogger( AuthenticInterceptor.class );

  @Autowired
  private SessionHandler sessionHandler;

  @Autowired
  private MenuService menuService;

  @Autowired
  private AccessMonitoringService accessMonitoringService;

  @Autowired
  private LoginService loginService;

  @Override
  public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
      throws ServletException {
    // Kit Wai - Start - 20180427
    LOGGER.debug("preHandle :: URI :: " + request.getRequestURI());
    Map<String, Object> params = new HashMap<String, Object>();

    // Request URI's as param
    String[] URI = ((String) request.getRequestURI()).split("/");
    params.put("mainDo", URI[URI.length - 1]);
    EgovMap item = new EgovMap();

    item = (EgovMap) loginService.checkByPass(params);

    /*
     * Skip validation if value found in SYS0088M Param - URI .do
     */
    if (item == null) {
      item = null;
      SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

      // Reset param
      params.clear();
      // UserIDType as parameter
      params.put("memTyp", sessionVO.getUserTypeId());
      item = (EgovMap) loginService.checkByPass(params);

      /*
       * Skip validation if value found in SYS0088M Param - Member Type
       */
      if (item != null) {
        String[] doListStr = ((String) item.get("bypassDoList")).split("\\|\\|\\|");

        List<String> doList = Arrays.asList(doListStr);

        /*
         * Only permits navigation/action within set URLs
         */
        if (!doList.contains(request.getRequestURI())) {
          LOGGER.debug("AuthenticInterceptor > AuthException [ URI : {}{}]", request.getContextPath(), request.getRequestURI());
          throw new AuthException(HttpStatus.UNAUTHORIZED, HttpStatus.UNAUTHORIZED.getReasonPhrase());
        }
      } else {
        if (VerifyRequest.isNotCallCenterRequest(request)) {
          if (sessionVO != null && sessionVO.getUserId() > 0) {
            checkAuthorized(sessionVO.getUserId(), request.getRequestURI());
          } else {
            if (!CommonUtils.nvl(request.getParameter("sKey")).equals( "" ) && !CommonUtils.nvl(request.getParameter("usrNm")).equals( "" )) {
              Map<String, Object> acsPrm = new HashMap<String, Object>();
              acsPrm.put( "userId", request.getParameter("usrNm") );
              acsPrm.put( "properiesUserSessionKey", request.getParameter("sKey") );
              LOGGER.debug(">>>>>>>>", request.getParameter("usrNm"));
              LOGGER.debug(">>>>>>>>", request.getParameter("sKey"));
              if (!chkAcessKey(acsPrm)) {
                throw new AuthException(HttpStatus.UNAUTHORIZED, HttpStatus.UNAUTHORIZED.getReasonPhrase());
              }
            } else {
              LOGGER.debug("AuthenticInterceptor > AuthException [ URI : {}{}]", request.getContextPath(), request.getRequestURI());
              throw new AuthException(HttpStatus.UNAUTHORIZED, HttpStatus.UNAUTHORIZED.getReasonPhrase());
            };
          }

        } else {
          LOGGER.info("[preHandle] this url is call by Callcenter.......");
        }
      }
    }
    // Kit Wai - End - 20180427
    return true;
  }

  /**
   * 권한 체크. : 2017-09-13 : 각 기능(CRUD) 권한 체크는 화면단에서 한다. 메뉴에 등록 된것만 체크.
   */
  private void checkAuthorized( int userId, String pgmPath ) {
    Map<String, Object> params = new HashMap<>();
    params.put( "userId", userId );
    params.put( "pgmPath", pgmPath );
    EgovMap pgmPahMenuAuth = menuService.getMenuAuthByPgmPath( params );
    // ONGHC - ADD FOR ACCESS CHECK FOR THOSE WHICH BOOKMARKED URL AND NOT ALLOW TO ACCESS
    if ( pgmPahMenuAuth == null ) {
      // CHECK ONLY FOR THOSE CONFIGURATED MENU (SYS0050M,  SYS0051M)
      int x = menuService.getCountCommAuth( params );
      if ( x > 0 ) {
        throw new AuthException( HttpStatus.UNAUTHORIZED, HttpStatus.UNAUTHORIZED.getReasonPhrase() );
      }
    }
    // 메뉴에 등록되어 있는 pgmPath 중 권한체크.
    if ( pgmPahMenuAuth != null && CommonUtils.isNotEmpty( pgmPahMenuAuth.get( "menuCode" ) )
      && !"Y".equals( pgmPahMenuAuth.get( "funcYn" ) ) ) {
      throw new AuthException( HttpStatus.FORBIDDEN, HttpStatus.FORBIDDEN.getReasonPhrase() );
    }
    // 메뉴에 등록된 uri 에 대한 menuCode.... 등록되지 않은 uri 호출이 된 경우에도 이전 메뉴를 가지고 있음.
    if ( pgmPahMenuAuth != null && CommonUtils.isNotEmpty( pgmPahMenuAuth.get( "menuCode" ) ) ) {
      SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
      sessionVO.setMenuCode( (String) pgmPahMenuAuth.get( "menuCode" ) );
    }
  }

  private boolean bypassAuthorized( HttpServletRequest request ) {
    Map<String, Object> params = new HashMap<String, Object>();
    // Request URI's as param
    String[] URI = ( (String) request.getRequestURI() ).split( "/" );
    params.put( "mainDo", URI[URI.length - 1] );
    EgovMap item = new EgovMap();
    item = (EgovMap) loginService.checkByPass( params );
    if ( item == null ) {
      return false;
    }
    else {
      return true;
    }
  }

  @Override
  public void postHandle( HttpServletRequest request, HttpServletResponse response, Object handler,
                          ModelAndView modelAndView )
    throws Exception {
    // check request to Callcenter
    if ( VerifyRequest.isNotCallCenterRequest( request ) ) {
      LOGGER.debug( "preHandle :: URI :: " + request );
      SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
      boolean flag = bypassAuthorized( request );
      if ( !flag ) {
        if ( sessionVO == null || sessionVO.getUserId() == 0 ) {
          if (!CommonUtils.nvl(request.getParameter("sKey")).equals( "" ) && !CommonUtils.nvl(request.getParameter("usrNm")).equals( "" )) {
            Map<String, Object> acsPrm = new HashMap<String, Object>();
            acsPrm.put( "userId", request.getParameter("usrNm") );
            acsPrm.put( "properiesUserSessionKey", request.getParameter("sKey") );
            if (!chkAcessKey(acsPrm)) {
              throw new AuthException(HttpStatus.UNAUTHORIZED, HttpStatus.UNAUTHORIZED.getReasonPhrase());
            }
          }
        }
        if ( modelAndView != null ) {
          Map<String, Object> params = new HashMap<>();
          params.put( "userId", sessionVO.getUserId() );
          params.put( "pgmPath", request.getRequestURI() );
          if ( request.getRequestURI().endsWith( ".do" ) ) {
            params.put( "userName", sessionVO.getUserName() );
            params.put( "systemId", AppConstants.LOGIN_WEB );
            params.put( "pgmCode", "-" );
            params.put( "ipAddr", CommonUtils.getClientIp( request ) );
            accessMonitoringService.insertAccessMonitoring( params );
          }
          // url 로 직접 접근시 menuCode 처리.
          modelAndView.getModelMap().put( AppConstants.CURRENT_MENU_CODE, sessionVO.getMenuCode() );
          modelAndView.getModelMap().put( AppConstants.PAGE_AUTH, menuService.getPageAuth( params ) );
          modelAndView.getModelMap().put( AppConstants.MENU_KEY, menuService.getMenuList( sessionVO ) );
          modelAndView.getModelMap().put( AppConstants.MENU_FAVORITES, menuService.getFavoritesList( sessionVO ) );
        }
      }
    }
    else {
      LOGGER.info( "[postHandle] this url is call by Callcenter......." );
    }
  }

  private boolean chkAcessKey(Map<String, Object> params ) {
    String accKey = CommonUtils.nvl(params.get( "properiesUserSessionKey" ));
    String actAccKey = "";
    try {
      actAccKey = CommonUtils.nvl(loginService.getPropUsrSessionKey(params));
      LOGGER.debug( "=actAccKey= " + actAccKey );
      LOGGER.debug( "=accKey= " + accKey );
      if (actAccKey.equals( accKey )) {
        return true;
      } else {
        return false;
      }
    } catch ( NoSuchAlgorithmException e ) {
      e.printStackTrace();
    }
    return false;
  }

}
