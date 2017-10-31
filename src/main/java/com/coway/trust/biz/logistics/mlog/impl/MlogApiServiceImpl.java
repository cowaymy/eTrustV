package com.coway.trust.biz.logistics.mlog.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.api.mobile.logistics.recevie.ConfirmReceiveDForm;
import com.coway.trust.api.mobile.logistics.recevie.ConfirmReceiveMForm;
import com.coway.trust.api.mobile.logistics.stocktransfer.StockTransferConfirmGiDForm;
import com.coway.trust.api.mobile.logistics.stocktransfer.StockTransferConfirmGiMForm;
import com.coway.trust.biz.logistics.mlog.MlogApiService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("MlogApiService")
public class MlogApiServiceImpl extends EgovAbstractServiceImpl implements MlogApiService {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "MlogApiMapper")
	private MlogApiMapper MlogApiMapper;

	@Override
	public List<EgovMap> getRDCStockList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getRDCStockList(params);
	}

	@Override
	public List<EgovMap> getStockbyHolderList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getStockbyHolderList(params);
	}

	@Override
	public List<EgovMap> getCommonQty(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getCommonQty(params);
	}

	@Override
	public List<EgovMap> getCt_CodyList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getCt_CodyList(params);
	}

	@Override
	public List<EgovMap> getInventoryOverallStock(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getInventoryOverallStock(params);
	}
	
	@Override
	public List<EgovMap> getAllStockList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getAllStockList(params);
	}

	@Override
	public List<EgovMap> getInventoryStockByHolder(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getInventoryStockByHolder(params);
	}

	
	@Override
	public List<EgovMap> StockReceiveList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.StockReceiveList(params);
	}

	@Override
	public List<EgovMap> selectStockReceiveSerial(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.selectStockReceiveSerial(params);
	}

	@Override
	public List<EgovMap> getMyStockList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getMyStockList(params);
	}

	@Override
	public List<EgovMap> getReturnPartsSearch(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getReturnPartsSearch(params);
	}

	@Override
	public List<EgovMap> getAlternativeFilterMList() {
		// TODO Auto-generated method stub
		return MlogApiMapper.getAlternativeFilterMList();
	}

	@Override
	public List<EgovMap> getAlternativeFilterDList() {
		// TODO Auto-generated method stub
		return MlogApiMapper.getAlternativeFilterDList();
	}

	@Override
	public List<EgovMap> getItemBankLocationList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getItemBankLocationList(params);
	}

	@Override
	public List<EgovMap> getItemBankItemList() {
		// TODO Auto-generated method stub
		return MlogApiMapper.getItemBankItemList();
	}

	@Override
	public List<EgovMap> getCommonReqHeader(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getCommonReqHeader(params);
	}
	
	@Override
	public List<EgovMap> getCommonReqParts(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getCommonReqParts(params);
	}
	
	@Override
	public List<EgovMap> getAuditStockResultDetail(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getAuditStockResultDetail(params);
	}
	
	@Override
	public List<EgovMap> getStockTransferReqStatusMList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getStockTransferReqStatusMList(params);
	}
	
	@Override
	public List<EgovMap> getStockTransferReqStatusDList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getStockTransferReqStatusDList(params);
	}
	
	
	@Override
	public List<EgovMap> getNonBarcodeM(Map<String, Object> params) {
		// TODO Auto-generated method stub	
		return MlogApiMapper.getNonBarcodeM(params);
	}
	
	
	@Override
	public List<EgovMap> getNonBarcodeDList(String invenAdjustLocId) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getNonBarcodeDList(invenAdjustLocId);
	}
	
	
	@Override
	public List<EgovMap> getBarcodeDList(String invenAdjustLocId) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getBarcodeDList(invenAdjustLocId);
	}
	
	@Override
	public List<EgovMap> getBarcodeCList(String invenAdjustLocId) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getBarcodeCList(invenAdjustLocId);
	}
	

	/**
	 * 현창배 추가
	 */

	@Override
	public List<EgovMap> getStockAuditResult(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getStockAuditResult(params);
	}

	@Override
	public List<EgovMap> getStockPriceList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getStockPriceList(params);
	}

	/**
	 * 인서트 추가
	 */
	
	@Override
	public void saveInvenReqTransfer(List<Map<String, Object>> reqTransferMList) {
		
		String seq = MlogApiMapper.selectStockMovementSeq();
		String headtitle = "SMO";
		Map<String, Object> insMap = null;
		if (reqTransferMList.size() > 0) {
			for (int i = 0; i < reqTransferMList.size(); i++) {
			
				insMap = (Map<String, Object>) reqTransferMList.get(i);
				insMap.put("reqno", headtitle + seq);

				MlogApiMapper.insStockMovementDetail(insMap);
				logger.info(" reqstno : {}", insMap);
								
			}	

			MlogApiMapper.insStockMovementHead(insMap);


			MlogApiMapper.insertStockBooking(insMap);
		}
	}
	
	
	@Override
	public Map<String, Object> selectStockMovementSerial(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.selectStockMovementSerial(params);
	}
	
	
	
	public void stockMovementReqDelivery(List<StockTransferConfirmGiMForm> stockTransferConfirmGiMForm) {

		String deliSeq = MlogApiMapper.selectDeliveryStockMovementSeq();
		Map<String, Object> insMap = new HashMap();
		// 2. insert ,54 , 55 , 61 ,56update start
		for (int i = 0; i < stockTransferConfirmGiMForm.size(); i++) {
			StockTransferConfirmGiMForm scgmf = stockTransferConfirmGiMForm.get(i);
				insMap.put("delno", deliSeq);
				insMap.put("itmcd", scgmf.getPartsCode());
				insMap.put("itmname", scgmf.getPartsName());
				insMap.put("reqstno", scgmf.getSmoNo());
				insMap.put("requestQty", scgmf.getRequestQty());
				insMap.put("userId", scgmf.getUserId());
				insMap.put("gtype", scgmf.getReqStatus());
				insMap.put("giptdate", scgmf.getRequestDate());
				
				// 55 insert
				MlogApiMapper.insertDeliveryStockMovementDetail(insMap);

			List<StockTransferConfirmGiDForm> list = scgmf.getStockTransferConfirmGiDetail();

			for (int j = 0; j < list.size(); j++) {

				StockTransferConfirmGiDForm scgdf = list.get(j);
				// 61insert
				insMap.put("serial", scgdf.getSerialNo());
				
				MlogApiMapper.insertMovementSerial(insMap);	
				
			}

			if (i == 0) {
				MlogApiMapper.insertDeliveryStockMovement(insMap);
				MlogApiMapper.updateRequestMovement(insMap);
			}
		}
		
	String[] delvcd = { deliSeq };
	insMap.put("parray", delvcd);
	insMap.put("userId",999999);
	//insMap.put("userId", params.get("userId"));
	// formMap.put("prgnm", params.get("prgnm"));
	insMap.put("refdocno", "");
	insMap.put("salesorder", "");

	MlogApiMapper.StockMovementIssue(insMap);
		

	}
	
	//Receive 미완성 
	@Override
	public void stockMovementCommonCancle(Map<String, Object> params) {
		
		Map<String, Object> cancleMap = new HashMap();
		cancleMap.put("userId", params.get("userId"));
		cancleMap.put("giptdate", params.get("requestDate"));
		cancleMap.put("smoNo", params.get("smoNo"));
		cancleMap.put("gtype", params.get("reqStatus"));
		
		logger.debug("userId    값 : {}", cancleMap.get("userId"));
		logger.debug("giptdate    값 : {}", cancleMap.get("giptdate"));
		logger.debug("smoNo    값 : {}", cancleMap.get("smoNo"));
		logger.debug("gtype    값 : {}", cancleMap.get("gtype"));
		
		logger.debug("cancleMap    값 : {}", cancleMap);
		
		String delvryNo = MlogApiMapper.StockMovementDelvryNo(cancleMap); // in : smo / out : delvry_no 
		
		if (delvryNo == null ){ // 일반 요청 상태
			MlogApiMapper.StockMovementReqstCancel(cancleMap);
		}else{ // 이동 상태
			String[] delvcd = new String[1];
			delvcd[0] = delvryNo;
			cancleMap.put("parray", delvcd);
			cancleMap.put("userId",999999);
			MlogApiMapper.StockMovementIssueCancel(cancleMap);
		}
		
	}	
	
		@Override
		public void stockMovementConfirmReceive(ConfirmReceiveMForm confirmReceiveMForm) {
			
			Map<String, Object> receiveMap = new HashMap();
			receiveMap.put("userId", confirmReceiveMForm.getUserId());
			receiveMap.put("giptdate", confirmReceiveMForm.getRequestDate());
			receiveMap.put("smoNo", confirmReceiveMForm.getSmoNo());
			receiveMap.put("gtype", confirmReceiveMForm.getReqStatus());
			
			logger.debug("receiveMap    값 : {}", receiveMap);
			
				List<ConfirmReceiveDForm> list = (List<ConfirmReceiveDForm>) confirmReceiveMForm.getConfirmReceiveDetail();			

				
				for (int j = 0; j < list.size(); j++) {
					ConfirmReceiveDForm form = list.get(j);
					
					logger.debug("partsCode    값 : {}",form.getPartsCode() );
					logger.debug("partsId    값 : {}", form.getPartsId());
					logger.debug("serialNo    값 : {}", form.getSerialNo());
					logger.debug("smoNoItem    값 : {}", form.getSmoNoItem());
					
				}
			
				List<EgovMap> delNo =MlogApiMapper.getDeliveryNo(receiveMap);
				
				for (int i = 0; i < delNo.size(); i++) {
					logger.debug("delNo    값 : {}", delNo.get(i));
				}
				
			
				int iCnt = 0;
				String tmpdelCd = "";
				String delyCd = "";
				if (delNo.size() > 0) {
					for (int i = 0; i < delNo.size(); i++) {
						Map<String, Object> map = (Map<String, Object>) delNo.get(i);

						//Map<String, Object> imap = new HashMap();

						String delCd = (String) map.get("delyno");
						if (delCd != null && !(tmpdelCd.equals(delCd))) {
							tmpdelCd = delCd;
							if (iCnt == 0) {
								delyCd = delCd;
							} else {
								delyCd += "∈" + delCd;
							}
							iCnt++;
						}
					}
				}
				
				String[] delvcd = delyCd.split("∈");
				
				for (int i = 0; i < delvcd.length; i++) {
				logger.debug("delvcd : {}", delvcd[i]);
				}
				
				receiveMap.put("parray", delvcd);
				receiveMap.put("userId",999999);
				// formMap.put("prgnm", params.get("prgnm"));
				receiveMap.put("refdocno", "");
				receiveMap.put("salesorder", "");
				logger.debug("receiveMap : {}", receiveMap);
				
				MlogApiMapper.StockMovementIssue(receiveMap);
						
				
		}
	
	
	
	
	
	
	
	
}
