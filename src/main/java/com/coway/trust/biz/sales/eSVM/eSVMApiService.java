package com.coway.trust.biz.sales.eSVM;

import java.util.List;

import com.coway.trust.api.mobile.sales.eSVM.eSVMApiDto;
import com.coway.trust.api.mobile.sales.eSVM.eSVMApiForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface eSVMApiService {

    List<EgovMap> selectQuotationList(eSVMApiForm param) throws Exception;

    eSVMApiDto selectSvmOrdNo(eSVMApiForm param) throws Exception;
    
    List<EgovMap> selectProductFilterList(eSVMApiForm param) throws Exception;

    eSVMApiDto selectOrderMemInfo(eSVMApiForm param) throws Exception;

}
