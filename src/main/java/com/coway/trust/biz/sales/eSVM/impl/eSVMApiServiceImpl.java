package com.coway.trust.biz.sales.eSVM.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.sales.eSVM.eSVMApiForm;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.sales.eKeyInApi.EKeyInApiService;
import com.coway.trust.biz.sales.eSVM.eSVMApiService;
import com.coway.trust.biz.sales.eSVM.impl.eSVMApiMapper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("eSVMApiService")
public class eSVMApiServiceImpl extends EgovAbstractServiceImpl implements eSVMApiService {

    private static final Logger logger = LoggerFactory.getLogger(eSVMApiServiceImpl.class);

    @Resource(name = "eSVMApiMapper")
    private eSVMApiMapper eSVMApiMapper;

    @Autowired
    private LoginMapper loginMapper;

    @Override
    public List<EgovMap> selectQuotationList(eSVMApiForm param) throws Exception {

        if (null == param) {
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }

        if (CommonUtils.isEmpty(param.getReqstDtFrom()) || CommonUtils.isEmpty(param.getReqstDtTo())) {
            throw new ApplicationException(AppConstants.FAIL, " Request Date  does not exist.");
        }

        if (CommonUtils.isEmpty(param.getSelectType())) {
            throw new ApplicationException(AppConstants.FAIL, "Select Type value does not exist.");
        } else {
            if (("2").equals(param.getSelectType()) && param.getSelectKeyword().length() < 5) {
                throw new ApplicationException(AppConstants.FAIL, "Please enter at least 5 characters.");
            }
        }

        if (CommonUtils.isEmpty(param.getRegId())) {
            throw new ApplicationException(AppConstants.FAIL, "User ID value does not exist.");
        }

        return eSVMApiMapper.selectQuotationList(eSVMApiForm.createMap(param));
    }

}
