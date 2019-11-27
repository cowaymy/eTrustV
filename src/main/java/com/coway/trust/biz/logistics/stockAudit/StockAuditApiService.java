package com.coway.trust.biz.logistics.stockAudit;

import java.util.List;
import java.util.Map;

import com.coway.trust.api.mobile.logistics.stockAudit.StockAuditApiDto;
import com.coway.trust.api.mobile.logistics.stockAudit.StockAuditApiFormDto;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : StockAuditApiService.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 10. 28.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
public interface StockAuditApiService {



    List<EgovMap> selectStockAuditList(StockAuditApiFormDto param);



    EgovMap selectStockAuditDetail(StockAuditApiFormDto param);



    Map<String, Object> selectStockAuditDetailList(StockAuditApiFormDto param);



    List<StockAuditApiDto> saveStockAudit(List<StockAuditApiDto> param) throws Exception;



    List<StockAuditApiDto> saveRequestApprovalStockAudit(List<StockAuditApiDto> param) throws Exception;
}
