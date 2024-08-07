package com.coway.trust.biz.logistics.stockAudit.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : StockAuditApiMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 10. 28.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Mapper("StockAuditApiMapper")
public interface StockAuditApiMapper {



    List<EgovMap> selectStockAuditList(Map<String, Object> params);



    EgovMap selectStockAuditDetail(Map<String, Object> params);



    List<EgovMap> selectStockAuditDetailList(Map<String, Object> params);



    int updateAppv3LOG0094M(Map<String, Object> params);



    int updateSaveLocStusCodeIdLOG0095M(Map<String, Object> params);



    int updateSaveLocStusCodeIdBarcodeLOG0096D(Map<String, Object> params);



    int updateSaveLocStusCodeIdLOG0096D(Map<String, Object> params);



    int updateRequestApproval(Map<String, Object> params);



    int insertStockAuditLocHistoryLOG0095M(Map<String, Object> params);



    int insertStockAuditItemHistoryLOG0096D(Map<String, Object> params);
}
