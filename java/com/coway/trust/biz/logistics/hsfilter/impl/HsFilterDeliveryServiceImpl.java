
package com.coway.trust.biz.logistics.hsfilter.impl;

import java.math.BigDecimal;
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
public  class HsFilterDeliveryServiceImpl extends EgovAbstractServiceImpl implements HsFilterDeliveryService
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
		//return hsFilterDeliveryMapper.selectHSFilterDeliveryList(params); chage
		return hsFilterDeliveryMapper.selectHSFilterDeliveryListCall(params);


	}


	@Override
	public List<EgovMap> selectHSFilterDeliveryPickingList(Map<String, Object> params) {


		//forecastMonth=02/2021, searchCDC=2010, searchBranchCb=
		if(params.get("forecastMonth") !="" || params.get("forecastMonth") !=null ){
			String date[] = (String[])(params.get("forecastMonth")).toString().split("/");
			params.put("yyyy", date[1]);
			params.put("mm", date[0]);
		}


		//return hsFilterDeliveryMapper.selectHSFilterDeliveryPickingList(params);

		return hsFilterDeliveryMapper.selectHSFilterDeliveryPickingListCall(params);



	}

	@Override
	public List<EgovMap> selectStockTransferRequestItem(Map<String, Object> params) {

		return hsFilterDeliveryMapper.selectStockTransferRequestItem(params);

	}

	@Override
	public List<EgovMap> selectDeliverydupCheck(Map<String, Object> params ) {

		return hsFilterDeliveryMapper.selectDeliverydupCheck(params);

	}


	@Override
	public String StocktransferReqDelivery(List<EgovMap> params,int userid) {

		String seq;
		boolean dupCheck = true;
		if (params.size() > 0) {
			Map<String, Object> insMap = null;
			for (int i = 0; i < params.size(); i++) {

				List<EgovMap> list = hsFilterDeliveryMapper.selectDeliverydupCheck(params.get(i));
				String ttmp1 = (String) params.get(i).get("reqstno");
				String ttmp2 = (String) params.get(i).get("itmcd");

				BigDecimal ttmp3 = (BigDecimal) params.get(i).get("reqstqty");
				BigDecimal ttmp4 = (BigDecimal) params.get(i).get("delyqty");

				//logger.info(" ttmp1 :ttmp2 : ttmp3 : ttmp4 {} : {} : {} : {}", ttmp1, ttmp2, ttmp3, ttmp4);
				if (list.size() > 0) {
					Map<String, Object> checkmap = null;
					checkmap = list.get(0);
					String tmp1 = (String) checkmap.get("reqstNo");
					String tmp2 = (String) checkmap.get("itmCode");
					BigDecimal tmp3 = (BigDecimal) checkmap.get("delvryQty");
					BigDecimal sum = ttmp4.add(tmp3);
					 int res;
				     res = sum.compareTo(ttmp3);
					if (ttmp1.equals(tmp1) && ttmp2.equals(tmp2) && (res==1)) {
						dupCheck = false;
					}
				}

			}
		}
		if (dupCheck) {
			seq = hsFilterDeliveryMapper.selectDeliveryStockTransferSeq();
			if (params.size() > 0) {
				Map<String, Object> insMap = null;
				for (int i = 0; i < params.size(); i++) {

					insMap = (Map<String, Object>) params.get(i);
					insMap.put("userId", userid);
					insMap.put("delno", seq);
					insMap.put("ttype", "US");
					insMap.put("mtype", "US03");
					//insMap.put("userId", params.get(i).get("userId"));
					hsFilterDeliveryMapper.deliveryStockTransferDetailIns(insMap);
				}
				hsFilterDeliveryMapper.deliveryStockTransferIns(insMap);

				for (int i = 0; i < params.size(); i++) { // Added for when select more than two diff order by hltang, 8-7-2021
					insMap = (Map<String, Object>) params.get(i);
					String reqstNo = (String) insMap.get("reqstno");

					hsFilterDeliveryMapper.updateRequestTransfer(reqstNo);
				}
			}
		} else {
			seq = "dup";
		}
		return seq;
	}


	@Override
	public List<EgovMap> selectStockTransferList(Map<String, Object> params) {

		return hsFilterDeliveryMapper.selectStockTransferList(params);

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
						insMap.put("pickingDevrQty", insMap.get("finalQty"));
						insMap.put("pickingBox", insMap.get("box"));
						insMap.put("pickingLoose", insMap.get("loose"));


						if((insMap.get("hsTableType")).toString().equals("L108M")){
							hsFilterDeliveryMapper.updateSTONo(insMap);
						}else{
							hsFilterDeliveryMapper.updateLog109MSTONo(insMap);
						}

					}
		}


		return reqNo;
	}




}
