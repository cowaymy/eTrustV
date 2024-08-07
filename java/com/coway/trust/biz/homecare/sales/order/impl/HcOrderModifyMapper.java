package com.coway.trust.biz.homecare.sales.order.impl;

import java.util.Map;

import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcOrderModifyMapper.java
 * @Description : Homecare Order Modify Mapper
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2020. 1. 16.   KR-SH        First creation
 * </pre>
 */
@Mapper("hcOrderModifyMapper")
public interface HcOrderModifyMapper {

	/**
	 * Homecare Order Modify - Promotion
	 * TO-DO Description
	 * @Author KR-SH
	 * @Date 2020. 1. 16.
	 * @param salesOrderMVO
	 * @return
	 */
	public int updateHcPromoPriceInfo(SalesOrderMVO salesOrderMVO);

	/**
	 * select Order Marster (SAL0001D)
	 * @Author KR-SH
	 * @Date 2020. 1. 15.
	 * @param params
	 * @return
	 */
	public EgovMap select_SAL0001D(Map<String, Object> params);

}
