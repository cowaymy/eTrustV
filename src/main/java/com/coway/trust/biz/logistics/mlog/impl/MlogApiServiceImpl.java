package com.coway.trust.biz.logistics.mlog.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.logistics.stocktransfer.StockTransferConfirmGiDForm;
import com.coway.trust.api.mobile.logistics.stocktransfer.StockTransferConfirmGiMForm;
import com.coway.trust.biz.logistics.mlog.MlogApiService;
import com.coway.trust.cmmn.exception.PreconditionException;

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
	

	// @Override
	// public List<EgovMap> StockReceiveList(Map<String, Object> params) {
	// // TODO Auto-generated method stub
	//
	// List<EgovMap> headerList = null;
	//
	// headerList= MlogApiMapper.StockReceiveList(params);
	// Map<String, Object> partsMap = new HashMap();
	//
	// for (int i = 0; i < headerList.size(); i++) {
	//
	// Map<String, Object> tmpMap = (Map<String, Object>) headerList.get(i);
	//
	// //delyno = (String) tmpMap.get("delyno");
	//
	// List<EgovMap> serialList = MlogApiMapper.selectStockReceiveSerial(tmpMap);
	//
	//// headerList.add(serialList.get(i));
	//// headerList.get(i).putAll((Map) serialList);
	// logger.debug("SerialList@@@@@! : {}", serialList.toString());
	//// logger.debug("SerialList@@@@@! : {}", headerList.toString());
	//
	//
	// }
	//
	// return headerList;
	// }

	/**
	 * 현창배 추가
	 */
//	@Override
//	public List<EgovMap> getBarcodeList(Map<String, Object> params) {
//		// TODO Auto-generated method stub
//		return MlogApiMapper.getBarcodeList(params);
//	}

//	@Override
//	public List<EgovMap> getNonBarcodeList(Map<String, Object> params) {
//		// TODO Auto-generated method stub
//		return MlogApiMapper.getNonBarcodeList(params);
//	}

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

//	@Override
//	public List<StrockMovementVoForMobile> getStockRequestStatusHeader(Map<String, Object> params) {
//		// TODO Auto-generated method stub
//		return MlogApiMapper.getStockRequestStatusHeader(params);
//	}
//
//	@Override
//	public List<StrockMovementVoForMobile> getRequestStatusParts(Map<String, Object> setMap) {
//		// TODO Auto-generated method stub
//		return MlogApiMapper.getRequestStatusParts(setMap);
//	}
	
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
				
				//insMap = (Map<String, Object>) reqTransferMList.get(i);
				
			}
			//insMap.put("reqno", headtitle + seq);

			MlogApiMapper.insStockMovementHead(insMap);

//			if (reqTransferMList.size() > 0) {
//				for (int i = 0; i < reqTransferMList.size(); i++) {
//					Map<String, Object> detailMap = (Map<String, Object>) reqTransferMList.get(i);
//					detailMap.put("reqno", headtitle + seq);
//					MlogApiMapper.insStockMovementDetail(detailMap);
//				}
//			}

			MlogApiMapper.insertStockBooking(insMap);
		}
	}
	
//	@Override
//	public void stockMovementReqDelivery(List<Map<String, Object>> reqTransferMList) {
//
//		String deliSeq = MlogApiMapper.selectDeliveryStockMovementSeq();
//		
//		if (reqTransferMList.size() > 0) {
//
//			Map<String, Object> insMap = null;
//
//			for (int i = 0; i < reqTransferMList.size(); i++) {
//
//				 insMap = (Map<String, Object>) reqTransferMList.get(i);
//
//				logger.info(" reqstno : {}", insMap.get("smoNo"));
//				insMap.put("reqstno", insMap.get("smoNo"));
//				insMap.put("delno", deliSeq);
//				insMap.put("itmcd", insMap.get("partsCode"));
//				insMap.put("itmname", insMap.get("partsName"));
//				insMap.put("serial", insMap.get("serialNo"));
//
//				//MlogApiMapper.insertDeliveryStockMovementDetail(insMap);
//			}
//	
//				Map<String, Object> insSerial = null;
//				for (int j = 0; j < reqTransferMList.size(); j++) {
//					logger.info(" seria 통과11111111111");
//					List<EgovMap> serialchek =MlogApiMapper.selectStockMovementSerial(insMap);
//					
//					//if(){
//						
//						MlogApiMapper.insertMovementSerial(insMap);	
//						
//						
////					}else{
////						throw new PreconditionException(AppConstants.FAIL, "Not Found Data");		
////					}
//					
//					
////					for (int i = 0; i < serialchek.size(); i++) {
////						logger.debug("serialchek 값 : {}", serialchek.get(i));
////					}
//					
//					
//					
////					if(String.valueOf(reqTransferMList.get(j).get("serialNo")) !=null  && String.valueOf(reqTransferMList.get(j).get("serialNo")) !=""){
////					if(("Y").equals(String.valueOf(reqTransferMList.get(j).get("serialChek")))){
//						logger.info(" seria 통과222222222");
//						
////						MlogApiMapper.insertMovementSerial(insMap);	
////						insSerial=reqTransferMList.get(j);
////						insSerial.put("serial",insSerial.get("serialNo"));
////						insSerial.put("delno", deliSeq);
////						insSerial.put("reqstno", insSerial.get("smoNo"));
////						insSerial.put("itmcd", insSerial.get("partsCode"));
////						
////						logger.info(" serial : {}", insSerial.get("serial"));
////						logger.info(" delno : {}", insSerial.get("delno"));
////						logger.info(" reqstno : {}", insSerial.get("reqstno"));
////						logger.info(" itmcd : {}", insSerial.get("itmcd"));						
//						
////						logger.info(" serialChek : {}", insSerial.get("serialChek"));
////						logger.info(" serialNo : {}", insSerial.get("serialNo"));
////						logger.info(" partsCode : {}", insSerial.get("partsCode"));
//
////					}			
//				}			
//		
//			
//			
//			//MlogApiMapper.insertDeliveryStockMovement(insMap);
//			//MlogApiMapper.updateRequestMovement(insMap);
//
////			stockMoveMapper.insertDeliveryStockMovement(insMap);
////			stockMoveMapper.updateRequestMovement((String) formMap.get("reqstno"));
////		}
////		String[] delvcd = { deliSeq };
////
////		formMap.put("parray", delvcd);
////		formMap.put("userId", params.get("userId"));
////		// formMap.put("prgnm", params.get("prgnm"));
////		formMap.put("refdocno", "");
////		formMap.put("salesorder", "");
////
////		stockMoveMapper.StockMovementIssue(formMap);
//		}
//	}
	
	@Override
	public Map<String, Object> selectStockMovementSerial(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.selectStockMovementSerial(params);
	}
	
	
	
	public void stockMovementReqDelivery(List<StockTransferConfirmGiMForm> stockTransferConfirmGiMForm) {

		System.out.println("인서트 시작!!!");

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
			// System.out.println("689Line ::: " + list.size());
			for (int j = 0; j < list.size(); j++) {

				StockTransferConfirmGiDForm scgdf = list.get(j);
				// 61insert
				System.out.println("692Line :::: " + scgdf.getSerialNo());
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
		
		
		// 2 end
		// }catch(Exception ex){
		//
		// }

	}
		
}
