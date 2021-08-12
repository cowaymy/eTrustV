package com.coway.trust.biz.payment.billing.service;

import java.util.List;
import java.util.Map;
import com.coway.trust.cmmn.model.SessionVO;
import egovframework.rte.psl.dataaccess.util.EgovMap;
public interface DiscountMgmtService{

    
    /**
	 * selectBasicInfo 조회
	 * @param params
	 * @return
	 */
    EgovMap selectBasicInfo(Map<String, Object> params);
    
    /**
	 * selectSalesOrderMById 조회
	 * @param params
	 * @return
	 */
    EgovMap selectSalesOrderMById(Map<String, Object> params);
    
    /**
	 * selectDiscountList 조회
	 * @param params
	 * @return
	 */
    List<EgovMap> selectDiscountList(Map<String, Object> params);
    
    /**
	 * saveDiscount 저장
	 * @param params
	 * @return
	 */
    EgovMap saveAddDiscount(Map<String, Object> params, SessionVO sessionVO);
    
    
    /**
	 * selectDiscountEntries 조회
	 * @param params
	 * @return
	 */
    String updDiscountEntry(Map<String, Object> params);

    
}
