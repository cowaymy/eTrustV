package com.coway.trust.biz.homecare.sales.order.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.sales.order.HcOrderCancelService;
import com.coway.trust.biz.sales.order.OrderCancelService;
import com.coway.trust.cmmn.exception.ApplicationException;
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

  	@Resource(name = "hcOrderCancelMapper")
  	private HcOrderCancelMapper hcOrderCancelMapper;

  	@Resource(name = "orderCancelService")
	private OrderCancelService orderCancelService;

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
	 * Homecare Order 취소
	 * @Author KR-SH
	 * @Date 2019. 10. 30.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @see com.coway.trust.biz.homecare.sales.order.HcOrderCancelService#hcSaveCancel(java.util.Map, org.springframework.ui.ModelMap, com.coway.trust.cmmn.model.SessionVO)
	 */
	@Override
	public Map<String, Object> hcSaveCancel(Map<String, Object> params, SessionVO sessionVO) {
		Map<String, Object> map = new HashMap<String, Object>();

		try {
			params.put("userId", sessionVO.getUserId());
			params.put("CTGroup", CommonUtils.nvl(params.get("dtSubGrp")));

		    int noRcd = orderCancelService.chkRcdTms(params);
		    int paramAnoOrdId = CommonUtils.intNvl(params.get("paramAnoOrdId"));
		    String paramOrdCtgryCd = CommonUtils.nvl(params.get("paramOrdCtgryCd"));   // Product Category Code

		    if (noRcd ==1){
				orderCancelService.saveCancel(params);

				// 같이 주문된 주문이 있는 경우.
				if(paramAnoOrdId > 0) {
					params.put("paramOrdId", paramAnoOrdId);
					params.put("appTypeId", paramOrdCtgryCd.equals(HomecareConstants.HC_CTGRY_CD.FRM) ? SalesConstants.APP_TYPE_CODE_ID_RENTAL : SalesConstants.APP_TYPE_CODE_ID_AUX);

					EgovMap callEntryMap = hcOrderCancelMapper.getCallEntryId(params);

					params.put("paramCallEntryId", CommonUtils.nvl(callEntryMap.get("callEntryId")));
					params.put("paramReqId", CommonUtils.nvl(callEntryMap.get("reqId")));
					params.put("paramStockId", CommonUtils.nvl(callEntryMap.get("stockId")));

					orderCancelService.saveCancel(params);
				}
				map.put("msg", "Record updated successfully.");
		    } else {
		    	map.put("msg", "Fail to update due to record had been updated by other user. Please SEARCH the record again later.");
		    }
		} catch (Exception e) {
			throw new ApplicationException(AppConstants.FAIL, "Order Cancellation Failed.");
		}
		return map;
	}

}
