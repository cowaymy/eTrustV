package com.coway.trust.biz.sales.pos;

import java.text.ParseException;


import java.util.List;
import java.util.Map;


import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PosEshopService {

	EgovMap  selectItemPrice(Map<String, Object> params)throws Exception;

	int insertPosEshopItemList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectItemList(Map<String, Object> params);

	List<EgovMap> selectItemList2(Map<String, Object> params);

	int removeEshopItemList(Map<String, Object> params) throws Exception;

	int updatePosEshopItemList(Map<String, Object> params) throws Exception;

	int insUpdPosEshopShipping(Map<String, Object> params) throws Exception;

	List<EgovMap> selectShippingList(Map<String, Object> params);

	int updatePosEshopShipping(Map<String, Object> params) throws Exception;

	List<EgovMap> selectItemImageList(Map<String, Object> params);

	List<EgovMap> selectCatalogList(Map<String, Object> params);

	int insertItemToCart(Map<String, Object> params) throws Exception;

	int getGrpSeqSAL0327T();

	List<EgovMap> selectItemCartList(Map<String, Object> params);

	List<EgovMap> selectItemCartList2(Map<String, Object> params);

	List<EgovMap> selectDefaultBranchList(Map<String, Object> params);

	List<EgovMap> selectTotalPrice(Map<String, Object> params);

	List<EgovMap> selectShippingFee(Map<String, Object> params);

	Map<String, Object> insertPosEshop(Map<String, Object> params) throws Exception;

	List<EgovMap> checkAvailableQtyStock(Map<String, Object> params);

	List<EgovMap> checkDiffWarehouse(Map<String, Object> params);

	List<EgovMap> checkDuplicatedStock(Map<String, Object> params);

	List<EgovMap> selectEshopList(Map<String, Object> params);

	List<EgovMap> selectPosEshopApprovalList(Map<String, Object> params);

	List<EgovMap> selectPosEshopApprovalViewList(Map<String, Object> params);

	Map<String, Object> insertPos(Map<String, Object> params) throws Exception;

	int rejectPos(Map<String, Object> params) throws Exception;

	int eshopUpdateCourierSvc(Map<String, Object> params) throws Exception;

	int completePos(Map<String, Object> params) throws Exception;

	List<EgovMap> selectEshopWhBrnchList(Map<String, Object> params);

	int deleteCartItem(Map<String, Object> params) throws Exception;

	List<EgovMap> selectEshopWhSOBrnchList() throws Exception;

	List<EgovMap> selectWhSOBrnchItemList() throws Exception;

	List<EgovMap> selectEshopStockList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectPaymentInfo(Map<String, Object> params);

	int confirmPayment(Map<String, Object> params);

	void deactivatePaymentAndEsn(Map<String, Object> params);

	void revertFloatingStockLOG0106M(Map<String, Object> params);

	List<EgovMap> checkValidationEsn(Map<String, Object> params);
}
