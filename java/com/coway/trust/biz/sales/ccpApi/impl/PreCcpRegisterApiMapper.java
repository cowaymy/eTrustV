package com.coway.trust.biz.sales.ccpApi.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName :  PreCcpRegisterApiMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 *
 *          <pre>
 * Date             		Author          		Description
 * -------------    	-----------     		-------------
 * 2023. 02. 08.    Low Kim Ching  First creation
 *          </pre>
 */

@Mapper("PreCcpRegisterApiMapper")
public interface PreCcpRegisterApiMapper {

  List<EgovMap> checkPreCcpResult(Map<String, Object> params);
  List<EgovMap> searchOrderSummaryList(Map<String, Object> params);

}
