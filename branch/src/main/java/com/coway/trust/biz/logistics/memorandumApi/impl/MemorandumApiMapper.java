package com.coway.trust.biz.logistics.memorandumApi.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : MemorandumApiMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 05.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Mapper("MemorandumApiMapper")
public interface MemorandumApiMapper {



    List<EgovMap> selectMemorandumList(Map<String, Object> params);
}
