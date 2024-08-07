package com.coway.trust.biz.sales.order;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface OrderConversionService {

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

	List<EgovMap> chkNewCnvrList(Map<String, Object> params);

	void saveNewConvertList(Map<String, Object> params);

	void savePayConvertList(Map<String, Object> params);

	List<EgovMap> chkPayCnvrList(Map<String, Object> params);

	List<EgovMap> paymodeConversionList(Map<String, Object> params);

	EgovMap paymodeConversionView(Map<String, Object> params);

	List<EgovMap> paymodeConversionViewItmList(Map<String, Object> params);

	List<EgovMap> selectOrdPayCnvrList(Map<String, Object> params);

	int countPaymodeCnvrExcelList(Map<String, Object> params);



	List<EgovMap> chkPayCnvrListPnp(Map<String, Object> params);
	void savePayConvertListPnp(Map<String, Object> params);

}
