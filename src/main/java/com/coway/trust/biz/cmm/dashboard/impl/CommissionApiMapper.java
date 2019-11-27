package com.coway.trust.biz.cmm.dashboard.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CommissionApiMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 *  * 2019. 11. 05.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Mapper("CommissionApiMapper")
public interface CommissionApiMapper {



    List<EgovMap> selectCommissionDashbordHP(Map<String, Object> params);



	List<EgovMap> selectCommissionDashbordCD(Map<String, Object> params);



	List<EgovMap> selectCommissionDashbordCT(Map<String, Object> params);



}
