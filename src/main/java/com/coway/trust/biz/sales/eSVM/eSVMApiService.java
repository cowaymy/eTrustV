package com.coway.trust.biz.sales.eSVM;

import java.util.List;

import com.coway.trust.api.mobile.sales.eSVM.eSVMApiForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface eSVMApiService {

    List<EgovMap> selectQuotationList(eSVMApiForm param) throws Exception;

}
