/**
 * 
 */
package com.coway.trust.biz.sales.promotion;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
public interface PromotionListService {
	List<EgovMap> selectPromotionList(Map<String, Object> params);
}
