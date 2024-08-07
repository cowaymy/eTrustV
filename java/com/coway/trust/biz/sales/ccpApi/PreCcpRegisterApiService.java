package com.coway.trust.biz.sales.ccpApi;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.coway.trust.api.mobile.sales.ccpApi.PreCcpRegisterApiDto;
import com.coway.trust.api.mobile.sales.ccpApi.PreCcpRegisterApiForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : PreCcpRegisterApiService.java
 * @Description : TO-DO Class Description
 *
 * @History
 *
 *          <pre>
 * Date                     Author                 Description
 * -------------           -----------             -------------
 * 2023. 02. 08.        Low Kim Ching      First creation
 *          </pre>
 */

public interface PreCcpRegisterApiService {

  List<EgovMap> checkPreCcpResult(PreCcpRegisterApiForm param) throws Exception;

  List<EgovMap> searchOrderSummaryList(PreCcpRegisterApiForm param) throws Exception;

}
