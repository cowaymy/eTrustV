package com.coway.trust.biz.api.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.StopWatch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.api.CommonApiService;
import com.coway.trust.biz.api.ProcurementApiService;
import com.coway.trust.biz.api.vo.procurement.CostCenterInfoVO;
import com.coway.trust.biz.api.vo.procurement.CostCenterReqForm;
import com.coway.trust.biz.api.vo.procurement.VendorPaymentReqForm;
import com.coway.trust.biz.api.vo.procurement.VendorPaymentVO;
import com.coway.trust.util.CommonUtils;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("procurementApiService")
public class ProcurementApiServiceimpl extends EgovAbstractServiceImpl implements ProcurementApiService {

	 private static final Logger LOGGER = LoggerFactory.getLogger( ProcurementApiServiceimpl.class );

	@Resource(name = "CommonApiMapper")
    private CommonApiMapper commonApiMapper;

	@Resource(name = "commonApiService")
    private CommonApiService commonApiService;

	@Resource(name = "ProcurementApiMapper")
    private ProcurementApiMapper procurementApiMapper;

	@Override
	public EgovMap getCostCtrGLaccBudgetCdInfo(HttpServletRequest request, CostCenterReqForm param) throws Exception {
		String respTm = null, apiUserId = "0", reqParam = null, respParam = null;
		EgovMap params = new EgovMap();
		EgovMap resultValue = new EgovMap();
		List<CostCenterInfoVO> costCenterList = new ArrayList<>();
		StopWatch stopWatch = new StopWatch();
		try {
			stopWatch.reset();
			stopWatch.start();
			params.put("budgetPlanYear", param.getBudgetPlanYear());
			params.put("budgetPlanMonth", param.getBudgetPlanMonth());

			Gson gson = new GsonBuilder().create();
			reqParam = gson.toJson(params);

            LOGGER.debug(">>> getCostCtrGLaccBudgetCdInfo reqParam :" + reqParam);

			apiUserId = verifyBasicAPIAuth(request);

			if (!apiUserId.equalsIgnoreCase("0")) {

				if (param.getBudgetPlanYear() != 0 && param.getBudgetPlanMonth() != 0) {
					ObjectMapper objectMapper = new ObjectMapper();
					List<EgovMap> data = procurementApiMapper.selectCostCtrGLaccBudgetCdInfo(params);

					if (data != null && data.size() > 0) {

						for (EgovMap info : data) {
							CostCenterInfoVO costCenter= objectMapper.convertValue(info, CostCenterInfoVO.class);
							costCenterList.add(costCenter);
	    				}

						resultValue.put("costCenter", costCenterList);

						respParam = gson.toJson(resultValue);

						params.put("statusCode", AppConstants.RESPONSE_CODE_SUCCESS);
						params.put("message", AppConstants.RESPONSE_DESC_SUCCESS);
						params.put("respParam", respParam.toString());
					} else {
						params.put("statusCode", AppConstants.RESPONSE_CODE_NOT_FOUND);
						params.put("message", "Record not found");
					}
				}
				else {
					params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
					params.put("message", "Both Budget Plan Year and Budget Plan Month are required");
				}
			} else {
				params.put("success", false);
				params.put("statusCode", AppConstants.RESPONSE_CODE_UNAUTHORIZED);
				params.put("message", AppConstants.RESPONSE_DESC_UNAUTHORIZED);
			}
		} catch (Exception e) {
			params.put("statusCode", AppConstants.FAIL);
			params.put("message", !CommonUtils.isEmpty(e.getMessage()) ? e.getMessage() : "Failed to get info.");
			e.printStackTrace();
			LOGGER.debug(">>> Error Message :" + e);
		} finally {
			finalizeResultValue(params, resultValue);
			stopWatch.stop();
			respTm = stopWatch.toString();
			insertApiLog(request, params, reqParam, respTm, apiUserId);
		}

		return resultValue;
	}

	@Override
	public EgovMap getVendorPaymentRecord(HttpServletRequest request, VendorPaymentReqForm param) throws Exception {
		String respTm = null, apiUserId = "0", reqParam = null, respParam = null;
		EgovMap params = new EgovMap();
		EgovMap resultValue = new EgovMap();
		List<VendorPaymentVO> vendorPaymentList = new ArrayList<>();
		StopWatch stopWatch = new StopWatch();
		try {
			stopWatch.reset();
			stopWatch.start();
			params.put("syncEmro", param.getSyncEmro());

			Gson gson = new GsonBuilder().create();
			reqParam = gson.toJson(params);

            LOGGER.debug(">>> getVendorPaymentRecord reqParam :" + reqParam);

			apiUserId = verifyBasicAPIAuth(request);

			if (!apiUserId.equalsIgnoreCase("0")) {
				if (param.getSyncEmro() != null) {
					ObjectMapper objectMapper = new ObjectMapper().configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false); // ignore syncEmro, crtDateOrd field
					List<EgovMap> data = procurementApiMapper.selectVendorPaymentRecord(params);

					if (data != null && data.size() > 0) {
						for (EgovMap info : data) {
							VendorPaymentVO vendorPayment= objectMapper.convertValue(info, VendorPaymentVO.class);
							vendorPaymentList.add(vendorPayment);
	    				}

						resultValue.put("vendor", vendorPaymentList);

						respParam = gson.toJson(resultValue);

						params.put("statusCode", AppConstants.RESPONSE_CODE_SUCCESS);
						params.put("message", AppConstants.RESPONSE_DESC_SUCCESS);
						params.put("respParam", respParam.toString());
					} else {
						params.put("statusCode", AppConstants.RESPONSE_CODE_NOT_FOUND);
						params.put("message", "Record not found");
					}
				}
				else{
					params.put("statusCode", AppConstants.RESPONSE_CODE_INVALID);
					params.put("message", "syncEmro are required");
				}
			} else {
				params.put("success", false);
				params.put("statusCode", AppConstants.RESPONSE_CODE_UNAUTHORIZED);
				params.put("message", AppConstants.RESPONSE_DESC_UNAUTHORIZED);
			}
		} catch (Exception e) {
			params.put("statusCode", AppConstants.FAIL);
			params.put("message", !CommonUtils.isEmpty(e.getMessage()) ? e.getMessage() : "Failed to get info.");
			e.printStackTrace();
			LOGGER.debug(">>> Error Message :" + e);
		} finally {
			finalizeResultValue(params, resultValue);
			stopWatch.stop();
			respTm = stopWatch.toString();
			insertApiLog(request, params, reqParam, respTm, apiUserId);
		}

		return resultValue;
	}

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
	public String verifyBasicAPIAuth(HttpServletRequest request) {
		EgovMap authorize = commonApiService.verifyBasicAPIAuth(request);

		if (String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS).equals(authorize.get("code").toString())) {
			return authorize.get("apiUserId").toString();
		}
		return "0";
	}

	@Override
    public void finalizeResultValue(EgovMap params, EgovMap resultValue) {

    	EgovMap oriResultValue = new EgovMap();
    	oriResultValue.putAll(resultValue);
    	resultValue.clear();

    	if ( params.get( "statusCode" ).toString().equals( "200" )
                || params.get( "statusCode" ).toString().equals( "201" ) ) {
            resultValue.put( "success", true );
        }
        else {
            resultValue.put( "success", false );
        }
        resultValue.put( "statusCode", params.get( "statusCode" ) );
        resultValue.put( "message", params.get( "message" ) );

        //reorder resultValue
    	resultValue.putAll(oriResultValue);
    }
}
