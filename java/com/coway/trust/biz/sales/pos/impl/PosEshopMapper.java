package com.coway.trust.biz.sales.pos.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("posEshopMapper")
public interface PosEshopMapper {


	EgovMap  selectItemPrice(Map<String, Object> params);

	int getSeqSAL0321D();

	int insertEshopItemList(Map<String, Object> params);

	List<EgovMap> selectItemList(Map<String, Object> params);

	List<EgovMap> selectItemList2(Map<String, Object> params);

	int removeEshopItemList(Map<String, Object> params);

	int updateEshopItemList(Map<String, Object> params);

	int getSeqSAL0322D();

	List<EgovMap> selectShippingList(Map<String, Object> params);

	int insertEshopShippingList(Map<String, Object> params);

	int removeEshopShippingList(Map<String, Object> params);

	int updatePosEshopShipping(Map<String, Object> params);

	List<EgovMap> selectItemImageList(Map<String, Object> params);

	List<EgovMap> selectCatalogList(Map<String, Object> params);

	int insertItemToCart(Map<String, Object> params);

	int getSeqSAL0327T();

	int getGrpSeqSAL0327T();

	List<EgovMap> selectItemCartList(Map<String, Object> params);

	List<EgovMap> selectItemCartList2(Map<String, Object> params);

	List<EgovMap> selectDefaultBranchList(Map<String, Object> params);

	List<EgovMap> selectTotalPrice(Map<String, Object> params);

	List<EgovMap> selectShippingFee(Map<String, Object> params);

	int getSeqSAL0325M();

	int getSeqSAL0326D();

	int getSeqSal0057D();

	int getSeqSal0058D();

	int getSeqPay0007D();

	int getSeqPay0016D();

	int getSeqPay0031D();

	int getSeqPay0032D();

	void insertSAL0325M(Map<String, Object> params);

	void insertSAL0326D(Map<String, Object> params);

	List<EgovMap> checkDiffWarehouse(Map<String, Object> params);

	List<EgovMap> checkDuplicatedStock(Map<String, Object> params);

	List<EgovMap> checkAvailableQtyStock(Map<String, Object> params);

	void  updateFloatingStockLOG0106M(Map<String, Object> params);

	void  reverseFloatingStockLOG0106M(Map<String, Object> params);

	List<EgovMap> selectEshopList(Map<String, Object> params);

	List<EgovMap> selectPosEshopApprovalList(Map<String, Object> params);

	List<EgovMap> selectPosEshopApprovalViewList(Map<String, Object> params);

	String getDocNo(Map<String, Object> params);

	EgovMap selectWarehouse(Map<String, Object> params);

	void insertPosMaster(Map<String, Object> params);

	void insertPosDetail(Map<String, Object> params);

	void updateEshopPosNo(Map<String, Object> params);

	void insertPosBilling(Map<String, Object> params);

	void updatePosMasterPosBillId(Map<String, Object> params);

	void insertPosOrderBilling(Map<String, Object> params);

	void insertPosTaxInvcMisc(Map<String, Object> params);

	void insertPosTaxInvcMiscSub(Map<String, Object> params);

	int rejectPos(Map<String, Object> params);

	int eshopUpdateCourierSvc(Map<String, Object> params);

	int completePos(Map<String, Object> params);

	List<EgovMap> selectEshopWhBrnchList(Map<String, Object> params);

	int deleteCartItem(Map<String, Object> params);

	List<EgovMap> selectEshopWhSOBrnchList();

	List<EgovMap> selectWhSOBrnchItemList();

	List<EgovMap> selectEshopStockList(Map<String, Object> params);

	List<EgovMap> selectPaymentInfo(Map<String, Object> params);

	int confirmPayment(Map<String, Object> params);

	void deactivatePaymentAndEsn(Map<String, Object> params);

	void revertFloatingStockLOG0106M(Map<String, Object> params);

	List<EgovMap> checkValidationEsn(Map<String, Object> params);

}
