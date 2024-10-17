package com.coway.trust.biz.api.impl;

import static com.coway.trust.AppConstants.MSG_NECESSARY;
import static com.coway.trust.AppConstants.REPORT_CLIENT_DOCUMENT;
import static com.coway.trust.AppConstants.REPORT_DOWN_FILE_NAME;
import static com.coway.trust.AppConstants.REPORT_FILE_NAME;
import static com.coway.trust.AppConstants.REPORT_VIEW_TYPE;

import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.api.CommonApiService;
import com.coway.trust.biz.api.SelfcarePortalApiService;
import com.coway.trust.biz.api.vo.selfcarePortal.FilterDetailVO;
import com.coway.trust.biz.api.vo.selfcarePortal.HServiceDetailVO;
import com.coway.trust.biz.api.vo.selfcarePortal.MembershipDetailVO;
import com.coway.trust.biz.api.vo.selfcarePortal.ProductDetailVO;
import com.coway.trust.biz.api.vo.selfcarePortal.SServiceDetailVO;
import com.coway.trust.biz.api.vo.selfcarePortal.UpcomingServiceDetailVO;
import com.coway.trust.biz.api.vo.chatbotInbound.CustomerVO;
import com.coway.trust.biz.api.vo.selfcarePortal.VerifyOderNoReqForm;
import com.coway.trust.util.CommonUtils;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.time.Month;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.StopWatch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("selfcarePortalApiService")
public class SelfcarePortalApiServiceImpl
    extends EgovAbstractServiceImpl
    implements SelfcarePortalApiService
{
    private static final Logger LOGGER = LoggerFactory.getLogger( SelfcarePortalApiServiceImpl.class );

    @Resource(name = "SelfcarePortalApiMapper")
    private SelfcarePortalApiMapper selfcarePortalApiMapper;

    @Resource(name = "CommonApiMapper")
    private CommonApiMapper commonApiMapper;

    @Resource(name = "commonApiService")
    private CommonApiService commonApiService;

    @Override
    public void rtnRespMsg( Map<String, Object> param )
    {
        Map<String, Object> params = new HashMap<>();
        params.put( "respCde", param.get( "statusCode" ) );
        params.put( "errMsg", param.get( "message" ) );
        params.put( "reqParam", param.get( "reqParam" ).toString() );
        params.put( "ipAddr", param.get( "ipAddr" ) );
        params.put( "prgPath", param.get( "prgPath" ) );
        params.put( "respTm", param.get( "respTm" ) );
        params.put( "respParam", param.containsKey( "respParam" )
                                                                  ? param.get( "respParam" ).toString().length() >= 4000
                                                                                                                         ? param.get( "respParam" )
                                                                                                                                .toString()
                                                                                                                                .substring( 0,
                                                                                                                                            4000 )
                                                                                                                         : param.get( "respParam" )
                                                                                                                                .toString()
                                                                  : "" );
        params.put( "apiUserId", param.get( "apiUserId" ) );
        commonApiMapper.insertApiAccessLog( params );
    }
    
    @Override
    public void insertApiLog(HttpServletRequest request, EgovMap params, String reqParam, String respTm, String apiUserId) {
    	// Insert log into API0004M
        params.put( "reqParam", CommonUtils.nvl( reqParam ) );
        params.put( "ipAddr", CommonUtils.getClientIp( request ) );
        params.put( "prgPath", StringUtils.defaultString( request.getRequestURI() ) );
        params.put( "respTm", CommonUtils.nvl( respTm ) );
        params.put( "apiUserId", CommonUtils.nvl( apiUserId ) );
        rtnRespMsg( params );
    }
    
    @Override
    public String verifyOrderNoParam(HttpServletRequest request, VerifyOderNoReqForm param){
    	EgovMap authorize = commonApiService.verifyBasicAPIAuth(request);
    	
    	if(String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS).equals(authorize.get("code").toString())){
            //check parameter
            if(CommonUtils.isEmpty(param.getOrderNo())){
                return "0";
            }
            else {
            	return authorize.get("apiUserId").toString();
            }
    	}
    	return "0";
    }
    
    @Override
    public void finalizeResultValue(EgovMap params, EgovMap resultValue) {
    	
    	EgovMap oriResultValue = new EgovMap();
    	oriResultValue.putAll(resultValue);
    	resultValue.clear();
    	
    	if ( params.get( "statusCode" ).toString().equals( "200" )
                || params.get( "statusCode" ).toString().equals( "201" ) )
        {
            resultValue.put( "success", true );
        }
        else
        {
            resultValue.put( "success", false );
        }
        resultValue.put( "statusCode", params.get( "statusCode" ) );
        resultValue.put( "message", params.get( "message" ) );
        
        //reorder resultValue
    	resultValue.putAll(oriResultValue);
    }
    
    @Override
    public EgovMap getProductDetail( HttpServletRequest request, VerifyOderNoReqForm param )
        throws Exception
    {
        String respTm = null, apiUserId = "0", reqParam = null, respParam = null;
        EgovMap params = new EgovMap();
        EgovMap resultValue = new EgovMap();
        ProductDetailVO prodDetail = new ProductDetailVO();
        MembershipDetailVO memDetail = new MembershipDetailVO();
        StopWatch stopWatch = new StopWatch();
        try
        {
            stopWatch.reset();
            stopWatch.start();

            apiUserId = verifyOrderNoParam(request, param);

            if(!apiUserId.equalsIgnoreCase("0")){
                String orderNo = param.getOrderNo().toString();
                params.put("orderNo", orderNo);

                Gson gson = new GsonBuilder().create();
                reqParam = gson.toJson(params);

                LOGGER.debug(">>> getProductDetail reqParam :" + reqParam);

                List<EgovMap> orderNoVO = selfcarePortalApiMapper.checkOrderNo(params);

                if(orderNoVO.size() > 0){
                	ObjectMapper objectMapper = new ObjectMapper();//.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
                	
                    EgovMap prodDetailData = selfcarePortalApiMapper.selectProductDetail(params);
                    prodDetail = objectMapper.convertValue(prodDetailData, ProductDetailVO.class);
                    if(prodDetail != null) {
                    	resultValue.put( "prodDetails", prodDetail );
                    	
                    	EgovMap memDetailData = selfcarePortalApiMapper.selectMembershipDetail(params);
                        memDetail = objectMapper.convertValue(memDetailData, MembershipDetailVO.class);
                        if(memDetail != null) 
                        	resultValue.put( "membershipDetails", memDetail );
                        respParam = gson.toJson(resultValue);

                        params.put("statusCode", AppConstants.RESPONSE_CODE_SUCCESS);
                        params.put("message", AppConstants.RESPONSE_DESC_SUCCESS);
                        params.put("respParam", respParam.toString());
                    }
                    else {
                    	params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
                        params.put("message", "Record not found");
                    }
                } else {
                    params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
                    params.put("message", "Record not found");
                }
            } else {
            	params.put("success", false);
                params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
                params.put("message", "Order number is required");
            }
        }
        catch ( Exception e )
        {
            params.put( "statusCode", AppConstants.FAIL );
            params.put( "message", !CommonUtils.isEmpty( e.getMessage() ) ? e.getMessage() : "Failed to get info." );
            e.printStackTrace();
            LOGGER.debug( ">>> Error Message :" + e );
        }
        finally
        {
        	finalizeResultValue(params, resultValue);
            stopWatch.stop();
            respTm = stopWatch.toString();
            insertApiLog(request, params, reqParam, respTm, apiUserId);
        }
        return resultValue;
    }

	@Override
	public EgovMap getServiceHistory(HttpServletRequest request, VerifyOderNoReqForm param) throws Exception {
        String respTm = null, apiUserId = "0", reqParam = null, respParam = null;
        EgovMap params = new EgovMap();
        EgovMap resultValue = new EgovMap();
        HServiceDetailVO hServiceDetail = new HServiceDetailVO();
        SServiceDetailVO sServiceDetail = new SServiceDetailVO();
        String serviceMode = null;
        StopWatch stopWatch = new StopWatch();
        try
        {
            stopWatch.reset();
            stopWatch.start();
            
            apiUserId = verifyOrderNoParam(request, param);

            if(!apiUserId.equalsIgnoreCase("0")){
                String orderNo = param.getOrderNo().toString();
                params.put("orderNo", orderNo);

                Gson gson = new GsonBuilder().create();
                reqParam = gson.toJson(params);

                LOGGER.debug(">>> getServiceHistory reqParam :" + reqParam);

                //Check order no
                List<EgovMap> orderNoVO = selfcarePortalApiMapper.checkOrderNo(params);

                if(orderNoVO.size() > 0){
                	ObjectMapper objectMapper = new ObjectMapper().configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
                	
                    EgovMap detailData = selfcarePortalApiMapper.selectServiceList(params);
                    if(detailData != null && detailData.size() > 0) {
                    	serviceMode = detailData.get("serviceMode").toString();
                    	if(serviceMode.equalsIgnoreCase("HS")) {
                    		hServiceDetail = objectMapper.convertValue(detailData, HServiceDetailVO.class);
                    		resultValue.put( "serviceDetails", hServiceDetail );
                    	}
                    	else {
                    		sServiceDetail = objectMapper.convertValue(detailData, SServiceDetailVO.class);
                    		resultValue.put( "serviceDetails", sServiceDetail );
                    	}

                        respParam = gson.toJson(resultValue);

                        params.put("statusCode", AppConstants.RESPONSE_CODE_SUCCESS);
                        params.put("message", AppConstants.RESPONSE_DESC_SUCCESS);
                        params.put("respParam", respParam.toString());
                    } else {
                        params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
                        params.put("message", "Record not found");
                    }
                } else {
                    params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
                    params.put("message", "Record not found");
                }
            }
            else {
            	params.put("success", false);
                params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
                params.put("message", "Order number is required");
            }
        }
        catch ( Exception e )
        {
            params.put( "statusCode", AppConstants.FAIL );
            params.put( "message", !CommonUtils.isEmpty( e.getMessage() ) ? e.getMessage() : "Failed to get info." );
            e.printStackTrace();
            LOGGER.debug( ">>> Error Message :" + e );
        }
        finally
        {
        	finalizeResultValue(params, resultValue);
            stopWatch.stop();
            respTm = stopWatch.toString();
            insertApiLog(request, params, reqParam, respTm, apiUserId);
        }
        return resultValue;
    }

	@Override
	public EgovMap getFilterInfo(HttpServletRequest request, VerifyOderNoReqForm param) throws Exception {
        String respTm = null, apiUserId = "0", reqParam = null, respParam = null;
        EgovMap params = new EgovMap();
        EgovMap resultValue = new EgovMap();
        List<FilterDetailVO> filterDetail = new ArrayList<FilterDetailVO>();
        String serviceMode = null;
        StopWatch stopWatch = new StopWatch();
        try
        {
            stopWatch.reset();
            stopWatch.start();

            apiUserId = verifyOrderNoParam(request, param);

            if(!apiUserId.equalsIgnoreCase("0")){
                String orderNo = param.getOrderNo().toString();
                params.put("orderNo", orderNo);

                Gson gson = new GsonBuilder().create();
                reqParam = gson.toJson(params);

                LOGGER.debug(">>> getFilterInfo reqParam :" + reqParam);

                //Check order no
                List<EgovMap> orderNoVO = selfcarePortalApiMapper.checkOrderNo(params);

                if(orderNoVO.size() > 0){
                	ObjectMapper objectMapper = new ObjectMapper();//.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
                	
                    List<EgovMap> detailData = selfcarePortalApiMapper.selectFilterInfo(params);
                    if(detailData.size() > 0) {
                    	for(EgovMap detail : detailData) {
                    		filterDetail.add(objectMapper.convertValue(detail, FilterDetailVO.class));
                    	}
                    	
                    	resultValue.put( "filterDetails", filterDetail );
                    	respParam = gson.toJson(resultValue);

                        params.put("statusCode", AppConstants.RESPONSE_CODE_SUCCESS);
                        params.put("message", AppConstants.RESPONSE_DESC_SUCCESS);
                        params.put("respParam", respParam.toString());
                        
                    } else {
                        params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
                        params.put("message", "Record not found");
                    }
                } else {
                    params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
                    params.put("message", "Record not found");
                }
            } else {
            	params.put("success", false);
                params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
                params.put("message", "Order number is required");
            }
        }
        catch ( Exception e )
        {
            params.put( "statusCode", AppConstants.FAIL );
            params.put( "message", !CommonUtils.isEmpty( e.getMessage() ) ? e.getMessage() : "Failed to get info." );
            e.printStackTrace();
            LOGGER.debug( ">>> Error Message :" + e );
        }
        finally
        {
        	finalizeResultValue(params, resultValue);
            stopWatch.stop();
            respTm = stopWatch.toString();
            insertApiLog(request, params, reqParam, respTm, apiUserId);
        }
        return resultValue;
    }
	
	@Override
	public EgovMap getUpcomingService(HttpServletRequest request, VerifyOderNoReqForm param) throws Exception {
        String respTm = null, apiUserId = "0", reqParam = null, respParam = null;
        EgovMap params = new EgovMap();
        EgovMap resultValue = new EgovMap();
        UpcomingServiceDetailVO upcomingServiceDetail = new UpcomingServiceDetailVO();
        String serviceMode = null;
        StopWatch stopWatch = new StopWatch();
        try
        {
            stopWatch.reset();
            stopWatch.start();

            apiUserId = verifyOrderNoParam(request, param);

            if(!apiUserId.equalsIgnoreCase("0")){
                String orderNo = param.getOrderNo().toString();
                params.put("orderNo", orderNo);

                Gson gson = new GsonBuilder().create();
                reqParam = gson.toJson(params);

                LOGGER.debug(">>> getFilterInfo reqParam :" + reqParam);

                //Check order no
                List<EgovMap> orderNoVO = selfcarePortalApiMapper.checkOrderNo(params);

                if(orderNoVO.size() > 0){
                	ObjectMapper objectMapper = new ObjectMapper();//.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
                	
                    EgovMap detailData = selfcarePortalApiMapper.selectUpcomingServices(params);
                    
                    if(detailData != null && detailData.size() > 0) {
                    	upcomingServiceDetail = objectMapper.convertValue(detailData, UpcomingServiceDetailVO.class);
                    	
                    	resultValue.put( "nextServiceDetails", upcomingServiceDetail );
                    	respParam = gson.toJson(resultValue);

                        params.put("statusCode", AppConstants.RESPONSE_CODE_SUCCESS);
                        params.put("message", AppConstants.RESPONSE_DESC_SUCCESS);
                        params.put("respParam", respParam.toString());
                        
                    } else {
                        params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
                        params.put("message", "Record not found");
                    }
                } else {
                    params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
                    params.put("message", "Record not found");
                }
            } else {
            	params.put("success", false);
                params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
                params.put("message", "Order number is required");
            }
        }
        catch ( Exception e )
        {
            params.put( "statusCode", AppConstants.FAIL );
            params.put( "message", !CommonUtils.isEmpty( e.getMessage() ) ? e.getMessage() : "Failed to get info." );
            e.printStackTrace();
            LOGGER.debug( ">>> Error Message :" + e );
        }
        finally
        {
        	finalizeResultValue(params, resultValue);
            stopWatch.stop();
            respTm = stopWatch.toString();
            insertApiLog(request, params, reqParam, respTm, apiUserId);
        }
        return resultValue;
    }
}
