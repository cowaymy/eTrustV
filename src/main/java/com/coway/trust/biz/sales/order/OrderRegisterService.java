/**
 * 
 */
package com.coway.trust.biz.sales.order;

import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
public interface OrderRegisterService {

	EgovMap selectSrvCntcInfo(Map<String, Object> params);

}
