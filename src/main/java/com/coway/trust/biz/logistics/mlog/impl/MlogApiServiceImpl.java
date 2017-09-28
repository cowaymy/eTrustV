package com.coway.trust.biz.logistics.mlog.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.mlog.MlogApiService;
import com.coway.trust.biz.logistics.stockmovement.vo.StrockMovementVoForMobile;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("MlogApiService")
public class MlogApiServiceImpl extends EgovAbstractServiceImpl implements MlogApiService {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "MlogApiMapper")
	private MlogApiMapper MlogApiMapper;

	@Override
	public List<EgovMap> getCTStockList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getCTStockList(params);
	}

	@Override
	public List<EgovMap> getRDCStockList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getRDCStockList(params);
	}

	@Override
	public List<EgovMap> getAllStockList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getAllStockList(params);
	}

	@Override
	public List<EgovMap> selectPartsStockHolder(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.selectPartsStockHolder(params);
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

	@Override
	public List<StrockMovementVoForMobile> getStockRequestStatusHeader(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getStockRequestStatusHeader(params);
	}

	@Override
	public List<StrockMovementVoForMobile> getRequestStatusParts(Map<String, Object> setMap) {
		// TODO Auto-generated method stub
		return MlogApiMapper.getRequestStatusParts(setMap);
	}

}
