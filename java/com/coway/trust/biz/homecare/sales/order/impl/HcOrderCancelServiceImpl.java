package com.coway.trust.biz.homecare.sales.order.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.sales.order.HcOrderCancelService;
import com.coway.trust.biz.homecare.sales.order.HcOrderListService;
import com.coway.trust.biz.sales.order.OrderCancelService;
import com.coway.trust.biz.sales.order.OrderListService;
import com.coway.trust.biz.sales.order.impl.OrderCancelMapper;
import com.coway.trust.biz.sales.order.impl.OrderListServiceImpl;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.homecare.HomecareConstants;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcOrderCancelServiceImpl.java
 * @Description : Homecare Cancel ServiceImpl
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 28.   KR-SH        First creation
 * </pre>
 */
@Service("hcOrderCancelService")
public class HcOrderCancelServiceImpl extends EgovAbstractServiceImpl implements HcOrderCancelService {

  private static Logger logger = LoggerFactory.getLogger(HcOrderCancelServiceImpl.class);

  @Resource(name = "hcOrderCancelMapper")
  private HcOrderCancelMapper hcOrderCancelMapper;

  @Resource(name = "orderCancelMapper")
  private OrderCancelMapper orderCancelMapper;

  @Resource(name = "orderCancelService")
	private OrderCancelService orderCancelService;

  @Resource(name = "hcOrderListService")
	private HcOrderListService hcOrderListService;

  	@Resource(name = "orderListService")
	private OrderListService orderListService;

  	@Autowired
	private MessageSourceAccessor messageAccessor;

	/**
	 * Homecare Order Cancellation List 데이터조회
	 * @Author KR-SH
	 * @Date 2019. 10. 28.
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> hcOrderCancellationList(Map<String, Object> params) {
		return hcOrderCancelMapper.hcOrderCancellationList(params);
	}

	/**
	 * Homecare Order Cancellation List 데이터조회
	 * @Author KR-SH
	 * @Date 2020. 1. 8.
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap hcOrderCancellationInfo(Map<String, Object> params) {
		EgovMap rtnMap = new EgovMap();
		List<EgovMap> rtnList = hcOrderCancelMapper.hcOrderCancellationList(params);
		if(rtnList.size() > 0) rtnMap = rtnList.get(0);

		return rtnMap;
	}

	/**
	 * Homecare Order 취소
	 * @Author KR-SH
	 * @Date 2019. 10. 30.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @see com.coway.trust.biz.homecare.sales.order.HcOrderCancelService#hcSaveCancel(java.util.Map, org.springframework.ui.ModelMap, com.coway.trust.cmmn.model.SessionVO)
	 */
	@Override
	public ReturnMessage hcSaveCancel(Map<String, Object> params, SessionVO sessionVO) {
		ReturnMessage map = new ReturnMessage();

		params.put("userId", sessionVO.getUserId());
		params.put("CTGroup", CommonUtils.nvl(params.get("dtSubGrp")));

	    int noRcd = orderCancelService.chkRcdTms(params);
	    int paramAnoOrdId = CommonUtils.intNvl(params.get("paramAnoOrdId"));
	    String paramOrdCtgryCd = CommonUtils.nvl(params.get("paramOrdCtgryCd"));   // Product Category Code

	    if (noRcd ==1) {
			orderCancelService.saveCancel(params);

			// 같이 주문된 주문이 있는 경우.
			if(paramAnoOrdId > 0) {
				params.put("paramOrdId", paramAnoOrdId);
				params.put("appTypeId", paramOrdCtgryCd.equals(HomecareConstants.HC_CTGRY_CD.FRM) ? SalesConstants.APP_TYPE_CODE_ID_RENTAL : SalesConstants.APP_TYPE_CODE_ID_AUX);

				params.put("cancellationType", "CAN");
				EgovMap callEntryMap = hcOrderCancelMapper.getCallEntryId(params);

				params.put("paramCallEntryId", CommonUtils.nvl(callEntryMap.get("callEntryId")));
				params.put("paramReqId", CommonUtils.nvl(callEntryMap.get("reqId")));
				params.put("paramStockId", CommonUtils.nvl(callEntryMap.get("stockId")));
        params.put("salesOrdId", paramAnoOrdId);

				if(params.get("callStusId") == "4" && paramOrdCtgryCd.equals(HomecareConstants.HC_CTGRY_CD.ACI)){
	        orderCancelMapper.updateCancelSAL0349D(params);
	     }

				orderCancelService.saveCancel(params);

			}
			map.setCode(AppConstants.SUCCESS);
			map.setMessage("Record updated successfully.");

	    } else {
	    	map.setCode(AppConstants.FAIL);
	    	map.setMessage("Fail to update due to record had been updated by other user. Please SEARCH the record again later.");
	    }

	    return map;
	}


	@Override
	public ReturnMessage hcAddProductReturnSerial(Map<String, Object> params, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		params.put("userId", sessionVO.getUserId());
		params.put("brnchId", sessionVO.getUserBranchId());
		params.put("srvOrdId", CommonUtils.nvl(params.get("hidSalesOrderId")));   // Matress OrderId
		params.put("salesOrdId", CommonUtils.nvl(params.get("hidSalesOrderId")));

		// return - Matress Product
		EgovMap rtnMat = orderListService.insertProductReturnResultSerial(params);
		/*if(AppConstants.FAIL.equals(CommonUtils.nvl(rtnMat.get("rtnCode")))) { // return Fail
			throw new ApplicationException(AppConstants.FAIL, CommonUtils.nvl(rtnMat.get("message")));
		}*/

		// select another order
		EgovMap hcOrderInfo = hcOrderListService.selectHcOrderInfo(params);

		// has Frame Order
		if(hcOrderInfo != null && CommonUtils.intNvl(hcOrderInfo.get("anoOrdId")) > 0) {
			int anoOrdId = CommonUtils.intNvl(hcOrderInfo.get("anoOrdId")); // Frame OrderId
			params.put("paramOrdId", anoOrdId);
			params.put("appTypeId", SalesConstants.APP_TYPE_CODE_ID_AUX);

			params.put("cancellationType", "PR");
			EgovMap callEntryMap = hcOrderCancelMapper.getCallEntryId(params);

			params.put("hidSalesOrderId", anoOrdId);
			params.put("callEntryId", CommonUtils.nvl(callEntryMap.get("callEntryId")));
			params.put("hidRefDocNo", CommonUtils.nvl(callEntryMap.get("retnNo")));
			params.put("hidTaxInvDSalesOrderNo", CommonUtils.nvl(hcOrderInfo.get("fraOrdNo")));
			params.put("serialNo", CommonUtils.nvl(params.get("serialNo2")));

			// return - Frame Product
			EgovMap rtnFra = orderListService.insertProductReturnResultSerial(params);
			/*if(AppConstants.FAIL.equals(CommonUtils.nvl(rtnFra.get("rtnCode")))) { // return Fail
				throw new ApplicationException(AppConstants.FAIL, CommonUtils.nvl(rtnFra.get("message")));
			}*/
		}

	// update the aircond bulk promotion disb = 1 when PR result status is completed
		if(params.get("hidInstallStatusCodeId") == "4" && params.get("hidCategoryId") == "7237" ){
        orderCancelMapper.updateCancelSAL0349D(params);
		}

		message.setCode(AppConstants.SUCCESS);
		message.setMessage(CommonUtils.nvl(rtnMat.get("message")));

		return message;
	}


	@Override
	public ReturnMessage saveDTAssignment(Map<String, Object> params, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		params.put("userId", sessionVO.getUserId());
		params.put("ordNo", CommonUtils.nvl(params.get("stkRetnOrdNo")));

		// Mattress Product - DT Assign
	    orderCancelService.saveCtAssignment(params);

	    // select another order
	 	EgovMap hcOrderInfo = hcOrderListService.selectHcOrderInfo(params);

	 	// has Frame Order
	 	if(hcOrderInfo != null) {
	 		params.put("ordNo", CommonUtils.nvl(hcOrderInfo.get("anoOrdNo")));
	 		EgovMap hcOrderCanInfo = hcOrderCancellationInfo(params);

	 		params.put("typeId", CommonUtils.nvl(hcOrderCanInfo.get("typeId")));
			params.put("stusCodeId", CommonUtils.nvl(hcOrderCanInfo.get("rsoStusId")));
			params.put("refId", CommonUtils.nvl(hcOrderCanInfo.get("refId")));

	 		EgovMap ctAssignmentInfo = orderCancelService.ctAssignmentInfo(params);
	 		if(ctAssignmentInfo == null) { // null ctAssignmentInfo
				throw new ApplicationException(AppConstants.FAIL, "Null - DT AssignMent Info");
			}

	 		params.put("stkRetnId", CommonUtils.nvl(ctAssignmentInfo.get("stkRetnId")));
	 		params.put("stkRetnCtFrom", CommonUtils.nvl(ctAssignmentInfo.get("memId")));
	 		params.put("stkRetnCtGrpFrom", CommonUtils.nvl(ctAssignmentInfo.get("ctGrp")));

	 		// Frame Product - DT Assign
		    orderCancelService.saveCtAssignment(params);
	 	}

	    message.setCode(AppConstants.SUCCESS);
	    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

	    return message;
	}

	@Override
    public List<EgovMap> getPartnerMemInfo(Map<String, Object> params){
    	return hcOrderCancelMapper.getPartnerMemInfo(params);
    }

}
