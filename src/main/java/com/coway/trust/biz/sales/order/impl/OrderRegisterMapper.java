/**
 * 
 */
package com.coway.trust.biz.sales.order.impl;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Mapper("orderRegisterMapper")
public interface OrderRegisterMapper {

	EgovMap selectSrvCntcInfo(Map<String, Object> params);
}
