
package com.coway.trust.biz.logistics.hsfilter.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.impl.CommonServiceImpl;
import com.coway.trust.biz.logistics.hsfilter.HsFilterDeliveryService;
import com.coway.trust.biz.logistics.stocktransfer.impl.StockTransferMapper;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("HsFilterDeliveryService")
public class HsFilterDeliveryServiceImpl extends EgovAbstractServiceImpl implements HsFilterDeliveryService
{
	private static final Logger logger = LoggerFactory.getLogger(CommonServiceImpl.class);

	@Resource(name = "HsFilterDeliveryMapper")
	private HsFilterDeliveryMapper hsFilterDeliveryMapper;

	@Resource(name = "stockTranMapper")
	private StockTransferMapper stocktran;

	@Override
	public List<EgovMap> selectHSFilterDeliveryBranchList(Map<String, Object> params) {


		return hsFilterDeliveryMapper.selectHSFilterDeliveryBranchList(params);
	}


	@Override
	public List<EgovMap> selectHSFilterDeliveryList(Map<String, Object> params) {


		logger.debug(params.toString());


		//forecastMonth=02/2021, searchCDC=2010, searchBranchCb=
		if(params.get("forecastMonth") !="" || params.get("forecastMonth") !=null ){

			String date[] = (String[])(params.get("forecastMonth")).toString().split("/");


			params.put("yyyy", date[1]);
			params.put("mm", date[0]);
		}
		return hsFilterDeliveryMapper.selectHSFilterDeliveryList(params);
	}


	@Override
	public List<EgovMap> selectHSFilterDeliveryPickingList(Map<String, Object> params) {


		//forecastMonth=02/2021, searchCDC=2010, searchBranchCb=
		if(params.get("forecastMonth") !="" || params.get("forecastMonth") !=null ){
			String date[] = (String[])(params.get("forecastMonth")).toString().split("/");
			params.put("yyyy", date[1]);
			params.put("mm", date[0]);
		}


		return hsFilterDeliveryMapper.selectHSFilterDeliveryPickingList(params);

	}





	@Override
	public String insertStockTransferInfo(Map<String, Object> params) {
		List<Object> insList = (List<Object>) params.get("all");

		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);



		//check   cdc stock qty
		if (insList.size() > 0) {
			for (int i = 0; i < insList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) insList.get(i);

				String searchCDCID  =  hsFilterDeliveryMapper.selectLocId(formMap.get("searchCDC").toString());

				insMap.put("tlocation",searchCDCID);
				insMap.put("rqty", insMap.get("finalQty"));
				insMap.put("itmcd", insMap.get("hsLoseItemCode"));

				int iCnt = stocktran.selectAvaliableStockQty(insMap);
				if (iCnt == 1 ){
					return "";
				}
			}
		}

		String seq = stocktran.selectStockTransferSeq();
		String reqNo = seq;

		String searchCDCID =  hsFilterDeliveryMapper.selectLocId(formMap.get("searchCDC").toString());
		String searchBranchCbID = hsFilterDeliveryMapper.selectLocId(formMap.get("searchBranchCb").toString());

		Map<String, Object> fMap = new HashMap<String, Object>();

		fMap.put("reqno", reqNo);
		fMap.put("userId", params.get("userId"));

		fMap.put("reqcrtdate", CommonUtils.getDateToFormat("dd/MM/yyyy"));
		fMap.put("dochdertxt", "from Hs filter Delivery Picking List");
		fMap.put("sttype", "US");
		fMap.put("smtype", "US03");
		fMap.put("tlocation", searchCDCID);
		fMap.put("flocation", searchBranchCbID);
		fMap.put("pridic", "M");


		logger.debug("=fMap==> "+fMap.toString());

		stocktran.insStockTransferHead(fMap);

		if (insList.size() > 0) {
			for (int i = 0; i < insList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) insList.get(i);

				insMap.put("reqno", seq);
				insMap.put("userId", params.get("userId"));

				String selectUomId = hsFilterDeliveryMapper.selectUomId(insMap.get("hsLoseItemCode").toString());

				insMap.put("itmcd",insMap.get("hsLoseItemCode") );
				insMap.put("itmname", insMap.get("hsLoseItemDesc"));
				insMap.put("uom", selectUomId);
				insMap.put("rqty", insMap.get("finalQty"));

				//logger.debug("=insMap==> "+insMap.toString());


				stocktran.insStockTransfer(insMap);
			}
		}
		// booking insert
		if ("M".equals((String)fMap.get("pridic"))){
			stocktran.insertStockBooking(fMap);
		}




		//check   cdc stock qty
		if (insList.size() > 0) {
					for (int i = 0; i < insList.size(); i++) {
						Map<String, Object> insMap = (Map<String, Object>) insList.get(i);

						insMap.put("refStoNo", reqNo);
						insMap.put("userId", params.get("userId"));
						int iCnt = hsFilterDeliveryMapper.updateSTONo(insMap);
					}
		}


		return reqNo;
	}




}
