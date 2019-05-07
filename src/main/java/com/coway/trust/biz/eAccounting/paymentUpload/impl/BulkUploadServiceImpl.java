package com.coway.trust.biz.eAccounting.paymentUpload.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.eAccounting.paymentUpload.BulkUploadService;
import com.coway.trust.biz.eAccounting.paymentUpload.impl.BulkUploadMapper;
import com.coway.trust.web.eAccounting.paymentUpload.BulkUploadController;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("bulkUploadService")

public class BulkUploadServiceImpl extends EgovAbstractServiceImpl implements BulkUploadService{

    private static final Logger LOGGER = LoggerFactory.getLogger(BulkUploadController.class);

    @Resource(name = "bulkUploadMapper")
    private BulkUploadMapper bulkUploadMapper;

    @Override
    public EgovMap getSupplierDtls(Map<String, Object> params) {
        return bulkUploadMapper.getSupplierDtls(params);
    }

    @Override
    public EgovMap getCcDtls(Map<String, Object> params) {
        return bulkUploadMapper.getCcDtls(params);
    }

    @Override
    public EgovMap getBgtDtls(Map<String, Object> params) {
        return bulkUploadMapper.getBgtDtls(params);
    }

    @Override
    public EgovMap getGLDtls(Map<String, Object> params) {
        return bulkUploadMapper.getGLDtls(params);
    }

    @Override
    public void clearBulkInvcTemp(Map<String, Object> params) {
        bulkUploadMapper.clearBulkInvcTemp(params);
    }

    @Override
    public void insertBulkInvc(Map<String, Object> params) throws Exception {
        bulkUploadMapper.insertBulkInvc(params);
    }

    @Override
    public EgovMap getUploadSeq() {
        return bulkUploadMapper.getUploadSeq();
    }

    @Override
    public List<EgovMap> selectUploadResultList( Map<String, Object> params) throws Exception {
        return bulkUploadMapper.selectUploadResultList(params);
    }

    @Override
    public EgovMap getBulkMaster(Map<String, Object> params) {
        return bulkUploadMapper.getBulkMaster(params);
    }

    @Override
    public List<EgovMap> getBulkDetails(Map<String, Object> params) {
        return bulkUploadMapper.getBulkDetails(params);
    }

    @Override
    public EgovMap getBatchSeq() {
        return bulkUploadMapper.getBatchSeq();
    }

    @Override
    public void insertBulkMaster(Map<String, Object> params) throws Exception {
        bulkUploadMapper.insertBulkMaster(params);
    }

    @Override
    public void insertBulkDetail(Map<String, Object> params) throws Exception {
        bulkUploadMapper.insertBulkDetail(params);
    }

    @Override
    public void insertApproveLineDetail(Map<String, Object> params) {
        bulkUploadMapper.insertApproveLineDetail(params);
    }

    @Override
    public void insertApproveManagement(Map<String, Object> params) {
        bulkUploadMapper.insertApproveManagement(params);
    }

    @Override
    public List<EgovMap> selectBulkInvcList(Map<String, Object> params) {
        return bulkUploadMapper.selectBulkInvcList(params);
    }

    @Override
    public EgovMap getApprDtls(Map<String, Object> params) {
        return bulkUploadMapper.getApprDtls(params);
    }

    @Override
    public void updateMasterAppr(Map<String, Object> params) {
        bulkUploadMapper.updateMasterAppr(params);
    }

    @Override
    public void updateDetailAppr(Map<String, Object> params) {
        bulkUploadMapper.updateDetailAppr(params);
    }

    @Override
    public List<EgovMap> getBulkItfDtls(Map<String, Object> params) {
        return bulkUploadMapper.getBulkItfDtls(params);
    }

    @Override
    public void insertBulkItf(Map<String, Object> params) {
         bulkUploadMapper.insertBulkItf(params);
    }

    @Override
    public List<EgovMap> getApprDtl(Map<String, Object> params) {
        return bulkUploadMapper.getApprDtl(params);
    }

    @Override
    public int getErrorCnt() {
        return bulkUploadMapper.getErrorCnt();
    }

    @Override
    public List<EgovMap> getBatchClmNos( Map<String, Object> params) throws Exception {
        return bulkUploadMapper.getBatchClmNos(params);
    }

    @Override
    public List<EgovMap> selectBulkInvcDtlList(Map<String, Object> params) {
        return bulkUploadMapper.selectBulkInvcDtlList(params);
    }

    @Override
    public String getRejectRsn(Map<String, Object> params) {
        return bulkUploadMapper.getRejectRsn(params);
    }
}