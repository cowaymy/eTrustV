package com.coway.trust.biz.eAccounting.paymentUpload.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("bulkUploadMapper")
public interface BulkUploadMapper {

    EgovMap getSupplierDtls(Map<String, Object> params);

    EgovMap getCcDtls(Map<String, Object> params);

    EgovMap getBgtDtls(Map<String, Object> params);

    EgovMap getGLDtls(Map<String, Object> params);

    void clearBulkInvcTemp(Map<String, Object> params);

    void insertBulkInvc(Map<String, Object> params) throws Exception;

    EgovMap getUploadSeq();

    List<EgovMap> selectUploadResultList(Map<String, Object> params) throws Exception;

    EgovMap getBulkMaster(Map<String, Object> params);

    List<EgovMap> getBulkDetails(Map<String, Object> params);

    EgovMap getBatchSeq();

    void insertBulkMaster(Map<String, Object> params) throws Exception;

    void insertBulkDetail(Map<String, Object> params) throws Exception;

    void insertApproveLineDetail(Map<String, Object> params);

    void insertApproveManagement(Map<String, Object> params);

    List<EgovMap> selectBulkInvcList(Map<String, Object> params);

    EgovMap getApprDtls(Map<String, Object> params);

    void updateMasterAppr(Map<String, Object> params);

    void updateDetailAppr(Map<String, Object> params);

    List<EgovMap> getBulkItfDtls(Map<String, Object> params);

    void insertBulkItf(Map<String, Object> params);

    List<EgovMap> getApprDtl(Map<String, Object> params);

    int getErrorCnt();

    List<EgovMap> getBatchClmNos(Map<String, Object> params) throws Exception;

    List<EgovMap> selectBulkInvcDtlList(Map<String, Object> params);

    String getRejectRsn(Map<String, Object> params);
}
