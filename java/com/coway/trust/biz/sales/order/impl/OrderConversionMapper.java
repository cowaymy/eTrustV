package com.coway.trust.biz.sales.order.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("orderConversionMapper")
public interface OrderConversionMapper {

	/**
	 * 글 목록을 조회한다.
	 *
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> orderConversionList(Map<String, Object> params);

	EgovMap orderConversionView(Map<String, Object> params);

	List<EgovMap> orderConversionViewItmList(Map<String, Object> params);

	List<EgovMap> orderCnvrValidItmList(Map<String, Object> params);

	List<EgovMap> orderCnvrInvalidItmList(Map<String, Object> params);

	void delCnvrItmSAL0073D(Map<String, Object> params);

	void updCnvrConfirm(Map<String, Object> params);

	void updCnvrDeactive(Map<String, Object> params);

	EgovMap orderCnvrInfo(Map<String, Object> params);

	void insertCnvrSAL0072D(Map<String, Object> params);

	void insertCnvrSAL0073D(Map<String, Object> setmap);

	void insertCnvrList(Map<String, Object> setmap);

	int crtSeqSAL0072D();

	EgovMap srvContractCnvrInfo(Map<String, Object> params);

	int crtSeqSAL0234D();

	void insertCnvrSAL0234D(Map<String, Object> params);

	void insertCnvrSAL0235D(Map<String, Object> params);

	void updSAL0001D(Map<String, Object> params);

	void updRegSAL0001D(Map<String, Object> params);

	void updSalesCRCSAL0074D(Map<String, Object> params);

	void updSalesRegCrcSAL0074D(Map<String, Object> params);

	void updSalesRegDdSAL0074D(Map<String, Object> params);

	void updSalesDDSAL0074D(Map<String, Object> params);

	void updSAL0077D(Map<String, Object> params);

	void updSrvCntrctCRCSAL0074D(Map<String, Object> params);

	void updSrvCntrctDDSAL0074D(Map<String, Object> params);

	void insertDeductSalesCRCSAL0236D(Map<String, Object> params);

	void insertDeductSalesREGSAL0236D(Map<String, Object> params);

	void insertDeductSalesDDSAL0236D(Map<String, Object> params);

	void insertDeductSrvCRCSAL0236D(Map<String, Object> params);

	void insertDeductSrvDDSAL0236D(Map<String, Object> params);

	int crtSeqSAL0236D();

	List<EgovMap> paymodeConversionList(Map<String, Object> params);

	EgovMap paymodeConversionView(Map<String, Object> params);

	List<EgovMap> paymodeConversionViewItmList(Map<String, Object> params);

	List<EgovMap> selectOrdPayCnvrList(Map<String, Object> params);

  int countPaymodeCnvrExcelList(Map<String, Object> params);

  EgovMap pnpOrderCnvrInfo(Map<String, Object> params);

  void updSalesSAL0074D(Map<String, Object> params);
}
