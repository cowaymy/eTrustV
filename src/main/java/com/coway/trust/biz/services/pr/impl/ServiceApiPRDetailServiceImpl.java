package com.coway.trust.biz.services.pr.impl;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.api.mobile.services.productRetrun.PRFailJobRequestDto;
import com.coway.trust.api.mobile.services.productRetrun.ProductReturnResultDto;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;
import com.coway.trust.biz.services.pr.ServiceApiPRDetailService;
import com.coway.trust.cmmn.exception.BizExceptionFactoryBean;
import com.coway.trust.cmmn.exception.BizException;
import com.coway.trust.cmmn.model.BizMsgVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : ServiceApiPRDetailServiceImpl.java
 * @Description : Mobile Product Return Data Save
 *
 * @History
 * Date              Author         Description
 * -------------  -----------  -------------
 * 2019. 09. 24.   Jun             First creation
 */
@Service("serviceApiPRDetailService")
public class ServiceApiPRDetailServiceImpl extends EgovAbstractServiceImpl implements ServiceApiPRDetailService {
	private static final Logger logger = LoggerFactory.getLogger(ServiceApiPRDetailServiceImpl.class);

	@Resource(name = "MSvcLogApiService")
	private MSvcLogApiService MSvcLogApiService;

	@Resource(name = "servicesLogisticsPFCService")
	private ServicesLogisticsPFCService servicesLogisticsPFCService;

	@Override
	public ResponseEntity<ProductReturnResultDto> productReturnResultProc(Map<String, Object> cvMp) throws Exception {
		String transactionId = "";
		String serviceNo = "";

		transactionId = String.valueOf(cvMp.get("transactionId"));
		serviceNo = String.valueOf(cvMp.get("serviceNo"));

		// CHECK CT VALID TO PERFORM THIS ACTION
		int memCnt = MSvcLogApiService.prdResultSync(cvMp);

		if (memCnt > 0) {
			int isPrdRtnCnt = MSvcLogApiService.isPrdRtnAlreadyResult(cvMp);

	        if (isPrdRtnCnt == 0) {
	        	try {
	        		// SP_RETURN_BILLING_EARLY_TERMI COMMIT DELETE
	        		EgovMap rtnValue = MSvcLogApiService.productReturnResult(cvMp);

	        		if (null != rtnValue) {
	        			HashMap spMap = (HashMap) rtnValue.get("spMap");
	        			if (!"000".equals(spMap.get("P_RESULT_MSG"))) {
	        				rtnValue.put("logerr", "Y");
	        			}
	        			// SP_SVC_LOGISTIC_REQUEST COMMIT STRING DELETE
	        			servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
	        		}
	        	}
	        	catch (Exception e) {
	        		String procTransactionId = transactionId;
	    			String procName = "ProductReturn";
	    			String procKey = serviceNo;
	    			String procMsg = "Failed to Save";
	    			String errorMsg = "[API] " + e.toString();
	    			throw new BizException("02", procTransactionId, procName, procKey, procMsg, errorMsg, null);

//	        		BizMsgVO bizMsgVO = new BizMsgVO();
//					bizMsgVO.setProcTransactionId(transactionId);
//					bizMsgVO.setProcKey(serviceNo);
//					bizMsgVO.setProcName("ProductReturn");
//					bizMsgVO.setProcMsg("Failed to Save");
//					bizMsgVO.setErrorMsg("[API] " + e.toString());
//					throw BizExceptionFactoryBean.getInstance().createBizException("02", bizMsgVO);
	        	}
	        }
	        else {
	        	String procTransactionId = transactionId;
    			String procName = "ProductReturn";
    			String procKey = serviceNo;
    			String procMsg = "NoTarget Data";
    			String errorMsg = "[API] [" + cvMp.get("userId") + "] THIS PR ALREADY NOT IN ACTIVE STATUS. ";
    			throw new BizException("04", procTransactionId, procName, procKey, procMsg, errorMsg, null);

//	        	BizMsgVO bizMsgVO = new BizMsgVO();
//				bizMsgVO.setProcTransactionId(transactionId);
//				bizMsgVO.setProcKey(serviceNo);
//				bizMsgVO.setProcName("ProductReturn");
//				bizMsgVO.setProcMsg("NoTarget Data");
//				bizMsgVO.setErrorMsg("[API] [" + cvMp.get("userId") + "] THIS PR ALREADY NOT IN ACTIVE STATUS. ");
//				throw BizExceptionFactoryBean.getInstance().createBizException("04", bizMsgVO);
	        }
		}
		else {
			String procTransactionId = transactionId;
			String procName = "ProductReturn";
			String procKey = serviceNo;
			String procMsg = "NoTarget Data";
			String errorMsg = "[API] [" + cvMp.get("userId") + "] THIS PR ALREADY NOT IN ACTIVE STATUS. ";
			throw new BizException("04", procTransactionId, procName, procKey, procMsg, errorMsg, null);

//			BizMsgVO bizMsgVO = new BizMsgVO();
//			bizMsgVO.setProcTransactionId(transactionId);
//			bizMsgVO.setProcKey(serviceNo);
//			bizMsgVO.setProcName("ProductReturn");
//			bizMsgVO.setProcMsg("NoTarget Data");
//			bizMsgVO.setErrorMsg("[API] [" + cvMp.get("userId") + "] IT IS NOT ASSIGNED CT CODE. ");
//			throw BizExceptionFactoryBean.getInstance().createBizException("01", bizMsgVO);
		}

		logger.debug("### PRODUCT RETURN FINAL PARAM : " + cvMp.toString());

	    return ResponseEntity.ok(ProductReturnResultDto.create(transactionId));
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRES_NEW)
	public ResponseEntity<PRFailJobRequestDto> prReAppointmentRequestProc(Map<String, Object> params) throws Exception {
		String serviceNo = String.valueOf(params.get("serviceNo"));

		MSvcLogApiService.savePrFailServiceLogs(params);
	    MSvcLogApiService.setPRFailJobRequest(params);

	    return ResponseEntity.ok(PRFailJobRequestDto.create(serviceNo));
	}
}
