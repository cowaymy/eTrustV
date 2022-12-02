package com.coway.trust.biz.sales.eSVM;

import java.util.List;

import com.coway.trust.api.mobile.sales.eSVM.eSVMApiDto;
import com.coway.trust.api.mobile.sales.eSVM.eSVMApiForm;
import com.coway.trust.biz.common.FileVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface eSVMApiService {

    List<EgovMap> selectQuotationList(eSVMApiForm param) throws Exception;

    eSVMApiDto selectSvmOrdNo(eSVMApiForm param) throws Exception;

    List<EgovMap> selectProductFilterList(eSVMApiForm param) throws Exception;

    eSVMApiDto selectPackageFilter(eSVMApiForm param) throws Exception;

    eSVMApiDto getPromoDisc(eSVMApiForm param) throws Exception;

    eSVMApiDto getFilterChargeSum(eSVMApiForm param) throws Exception;

    List<EgovMap> selectFilterList(eSVMApiForm param) throws Exception;

    eSVMApiDto selectOrderMemInfo(eSVMApiForm param) throws Exception;

    eSVMApiDto getOrderCurrentBillMonth(eSVMApiForm param) throws Exception;

    eSVMApiDto saveQuotationReq(eSVMApiForm param) throws Exception;

    eSVMApiDto cancelSMQ(eSVMApiForm param) throws Exception;

    int insertUploadPaymentFile(List<FileVO> list, eSVMApiDto param);

    eSVMApiDto insertPSM(eSVMApiForm param) throws Exception;

    List<EgovMap> selectPSMList(eSVMApiForm param) throws Exception;

    List<EgovMap> selectESvmAttachment(eSVMApiForm param) throws Exception;

    eSVMApiDto removePsmAttachment(eSVMApiForm param) throws Exception;

    int updatePaymentUploadFile(List<FileVO> list, eSVMApiDto param);

    eSVMApiDto updatePaymentUploadFile_1(eSVMApiForm param) throws Exception;

    eSVMApiDto getMemberLevel(eSVMApiForm param) throws Exception;

    eSVMApiDto selectEosEomDt(eSVMApiForm param) throws Exception;
}
