package com.coway.trust.biz.logistics.materialdocument;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface MaterialDocumentService {

	List<EgovMap> selectLocation(Map<String, Object> params);

	List<EgovMap> MaterialDocSearchList(Map<String, Object> params);

	List<EgovMap> MaterialDocMovementType(Map<String, Object> params);

	// 20191122 KR-OHK Serial List Add
	List<EgovMap> selectMaterialDocSerialList(Map<String, Object> params);

	List<EgovMap> MaterialDocSearchListUpTo(Map<String, Object> params);



/*	List<EgovMap> selectStockMovementMainList(Map<String, Object> params);

	List<EgovMap> selectStockMovementDeliveryList(Map<String, Object> params);

	List<EgovMap> selectTolocationItemList(Map<String, Object> smap);

	int stockMovementItemDeliveryQty(Map<String, Object> params);

	Map<String, Object> selectStockMovementDataDetail(String param);

	void deleteDeliveryStockMovement(Map<String, Object> param);

	List<EgovMap> addStockMovementInfo(Map<String, Object> param);

	void stockMovementReqDelivery(Map<String, Object> param);

	List<EgovMap>  selectStockMovementSerial(Map<String, Object> params);

	List<EgovMap> stockMovementDeliveryIssue(Map<String, Object> params);

	List<EgovMap> selectStockMovementDeliverySerial(Map<String, Object> params);

	List<EgovMap> selectStockMovementMtrDocInfoList(Map<String, Object> params);*/

}
