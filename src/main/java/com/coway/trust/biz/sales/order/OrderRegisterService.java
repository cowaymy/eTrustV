/**
 * 
 */
package com.coway.trust.biz.sales.order;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
public interface OrderRegisterService {

	EgovMap selectSrvCntcInfo(Map<String, Object> params);

	EgovMap selectStockPrice(Map<String, Object> params);

	List<EgovMap> selectDocSubmissionList(Map<String, Object> params);

	List<EgovMap> selectPromotionByAppTypeStock(Map<String, Object> params);

	EgovMap selectProductPromotionPriceByPromoStockID(Map<String, Object> params);

	EgovMap selectTrialNo(Map<String, Object> params);

}
