package com.coway.trust.biz.sales.pos;

import java.text.ParseException;


import java.util.List;
import java.util.Map;


import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PosEshopService {

	EgovMap  selectItemPrice(Map<String, Object> params)throws Exception;

	Map<String, Object> insertPosEshopItemList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectItemList(Map<String, Object> params);

	List<EgovMap> selectItemList2(Map<String, Object> params);

	Map<String, Object> removeEshopItemList(Map<String, Object> params) throws Exception;

	Map<String, Object> updatePosEshopItemList(Map<String, Object> params) throws Exception;

	void insUpdPosEshopShipping(Map<String, Object> params) throws Exception;

	List<EgovMap> selectShippingList(Map<String, Object> params);

	Map<String, Object> updatePosEshopShipping(Map<String, Object> params) throws Exception;

	List<EgovMap> selectItemImageList(Map<String, Object> params);

	List<EgovMap> selectCatalogList(Map<String, Object> params);

	Map<String, Object> insertItemToCart(Map<String, Object> params) throws Exception;

	int getGrpSeqSAL0327T();

	List<EgovMap> selectItemCartList(Map<String, Object> params);

	List<EgovMap> selectItemCartList2(Map<String, Object> params);

	List<EgovMap> selectDefaultBranchList(Map<String, Object> params);

	List<EgovMap> selectTotalPrice(Map<String, Object> params);

	List<EgovMap> selectShippingFee(Map<String, Object> params);

	Map<String, Object> insertPosEshop(Map<String, Object> params) throws Exception;

	List<EgovMap> checkDiffWarehouse(Map<String, Object> params);

	List<EgovMap> selectEshopList(Map<String, Object> params);

	List<EgovMap> selectPosEshopApprovalList(Map<String, Object> params);

	List<EgovMap> selectPosEshopApprovalViewList(Map<String, Object> params);

	Map<String, Object> insertPos(Map<String, Object> params) throws Exception;

	int rejectPos(Map<String, Object> params) throws Exception;

	int eshopUpdateCourierSvc(Map<String, Object> params) throws Exception;

	int completePos(Map<String, Object> params) throws Exception;




}
