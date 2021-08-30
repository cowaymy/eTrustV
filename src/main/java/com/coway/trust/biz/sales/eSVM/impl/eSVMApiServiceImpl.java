package com.coway.trust.biz.sales.eSVM.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.sales.eKeyInApi.EKeyInApiDto;
import com.coway.trust.api.mobile.sales.eSVM.eSVMApiDto;
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

    @Override
    public eSVMApiDto selectSvmOrdNo(eSVMApiForm param) throws Exception {

        if(null == param) {
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }

        EgovMap svmOrdDet = eSVMApiMapper.selectSvmOrdNo(eSVMApiForm.createMap(param));
        eSVMApiDto rtn = new eSVMApiDto();

        if(svmOrdDet.isEmpty()) {
            throw new ApplicationException(AppConstants.FAIL, "No order found or this order is not under complete status or activation status");
        } else {
            int stkId = Integer.parseInt(svmOrdDet.get("stkId").toString());
            int[] discontinueStk = {1, 651, 218, 689, 216, 687, 3, 653};
            List<Object> discontinueList = new ArrayList<Object>();
            for(int i = 0; i < discontinueStk.length; i++) {
                discontinueList.add(discontinueStk[i]);
            }

            if(discontinueList.indexOf(stkId) >= 0) {
                throw new ApplicationException(AppConstants.FAIL, "Product have been discontinued. Therefore, create new quotation is not allowed");
            }

            rtn = eSVMApiDto.create(eSVMApiMapper.selectOrderMemInfo(eSVMApiForm.createMap(param)));

            // [Filter Tab]
            List<EgovMap> selectProductFilterList = eSVMApiMapper.selectProductFilterList(eSVMApiForm.createMap(param));
//            List<eSVMApiDto> productFilterList = selectProductFilterList.stream().map(r -> eSVMApiDto.create(r)).collect(Collectors.toList());
//            rtn.setProductFilterList(productFilterList);
            rtn.setProductFilterList(selectProductFilterList.stream().map(r -> eSVMApiDto.create(r)).collect(Collectors.toList()));

            // [Membership Tab]
            // Type of Package
            List<EgovMap> selectComboPackageList = eSVMApiMapper.selectComboPackageList(eSVMApiForm.createMap(param));
            List<eSVMApiDto> comboPackageList = selectComboPackageList.stream().map(r -> eSVMApiDto.create(r)).collect(Collectors.toList());
            rtn.setPackageComboList(comboPackageList);

            // Package Promotion
            List<EgovMap> selectPackagePromoList = eSVMApiMapper.selectPackagePromo(eSVMApiForm.createMap(param));
            List<eSVMApiDto> packagePromoList = selectPackagePromoList.stream().map(r -> eSVMApiDto.create(r)).collect(Collectors.toList());
            rtn.setPackagePromoList(packagePromoList);

            // Filter Promotion
            List<EgovMap> selectFilterPromoList = eSVMApiMapper.selectFilterPromo(eSVMApiForm.createMap(param));
            List<eSVMApiDto> filterPromoList = selectFilterPromoList.stream().map(r -> eSVMApiDto.create(r)).collect(Collectors.toList());
            rtn.setFilterPromoList(filterPromoList);
        }
        return rtn;
    }

    @Override
    public List<EgovMap> selectProductFilterList(eSVMApiForm param) throws Exception {

        if (null == param) {
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }

        return eSVMApiMapper.selectProductFilterList(eSVMApiForm.createMap(param));
    }

    @Override
    public eSVMApiDto selectOrderMemInfo(eSVMApiForm param) throws Exception {

        if(null == param) {
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }

        if (CommonUtils.isEmpty(param.getSalesOrdId()) || param.getSalesOrdId() <= 0) {
            throw new ApplicationException(AppConstants.FAIL, "Sales order ID value does not exist.");
        }
        eSVMApiDto selectOrderMemDetail = eSVMApiDto.create(eSVMApiMapper.selectOrderMemInfo(eSVMApiForm.createMap(param)));
        return selectOrderMemDetail;
    }

    // TO-DO
    // Query Promotion package on change for employee dropdown/checkbox
}
