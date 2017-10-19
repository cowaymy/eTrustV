package com.coway.trust.biz.logistics.mlog.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.mlog.MlogApiService;
import com.coway.trust.biz.logistics.mlog.vo.StrockMovementVoForMobile;

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
		
		System.out.println("userId :::   "+params.get("userId"));
		System.out.println("searchType  ::  "+params.get("searchType"));
		System.out.println("searchKeyword ::"+params.get("searchKeyword"));
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
	@Override
	public List<EgovMap> getBarcodeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getBarcodeList(params);
	}

	@Override
	public List<EgovMap> getNonBarcodeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getNonBarcodeList(params);
	}

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

}
