package com.coway.trust.biz.sales.eSVM.impl;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
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

            // Set hiddenHasFilterCharge from ProductFilterList
            param.setFlag("Y");
            List<EgovMap> selectProductFilterList = eSVMApiMapper.selectProductFilterList(eSVMApiForm.createMap(param));
            String hiddenHasFilterCharge = "";
            Map<String, String> listItem = selectProductFilterList.get(0);
            Iterator<Entry<String, String>> it = listItem.entrySet().iterator();
            while(it.hasNext()) {
                Map.Entry pair = (Map.Entry)it.next();
                hiddenHasFilterCharge = pair.getValue().toString();
            }
            logger.debug("hiddenHasFilterCharge.HiddenHasFilterCharge :: " + hiddenHasFilterCharge);
            rtn.setHiddenHasFilterCharge(Integer.parseInt(hiddenHasFilterCharge));

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

        logger.info("===== selectProductFilterList =====");
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

    @Override
    public eSVMApiDto selectPackageFilter(eSVMApiForm param) throws Exception {

        if(null == param) {
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }

        eSVMApiDto rtn = new eSVMApiDto();

        // Package Promotion
        List<EgovMap> selectPackagePromoList = eSVMApiMapper.selectPackagePromo(eSVMApiForm.createMap(param));
        List<eSVMApiDto> packagePromoList = selectPackagePromoList.stream().map(r -> eSVMApiDto.create(r)).collect(Collectors.toList());
        rtn.setPackagePromoList(packagePromoList);

        // Filter Promotion
        List<EgovMap> selectFilterPromoList = eSVMApiMapper.selectFilterPromo(eSVMApiForm.createMap(param));
        List<eSVMApiDto> filterPromoList = selectFilterPromoList.stream().map(r -> eSVMApiDto.create(r)).collect(Collectors.toList());
        rtn.setFilterPromoList(filterPromoList);

        // Get default package info
        // mNewQuotationPop.jsp :: fn_getMembershipPackageInfo(_id)
        String zeroRatYn = "Y";
        String eurCertYn = "Y";

        int zeroRat = eSVMApiMapper.selectGSTZeroRateLocation(eSVMApiForm.createMap(param));
        if(zeroRat > 0) zeroRatYn = "N";
        param.setZeroRatYn(zeroRatYn);

        int eurCert = eSVMApiMapper.selectGSTEURCertificate(eSVMApiForm.createMap(param));
        if(eurCert > 0) eurCertYn = "N";
        param.setEurCertYn(eurCertYn);

        EgovMap packageInfo = eSVMApiMapper.mPackageInfo(eSVMApiForm.createMap(param));

        logger.debug("srvMemPacId :: " + packageInfo.get("srvMemPacId").toString());

        if(CommonUtils.isEmpty(packageInfo.get("srvMemPacId"))) {
            rtn.setHiddenHasPackage(0);
            rtn.setBsFreq("");
            rtn.setPackagePrice(0);
            rtn.setHiddenNormalPrice(0);
        } else {

            logger.debug("srvMemItmPrc :: " + packageInfo.get("srvMemItmPrc").toString());

            int year = param.getSubYear() /12;
            int pkgPrice = Math.round(Integer.parseInt(packageInfo.get("srvMemItmPrc").toString()) * year);
            rtn.setZeroRatYn(zeroRatYn);
            rtn.setEurCertYn(eurCertYn);

            logger.debug("year :: " + Integer.toString(year));
            logger.debug("pkgPrice :: " + Integer.toString(pkgPrice));

            rtn.setHiddenHasPackage(1);
            rtn.setBsFreq(packageInfo.get("srvMemItmPriod").toString() + " month(s)");
            rtn.setHiddenBsFreq(packageInfo.get("srvMemItmPriod").toString());

            rtn.setHiddenNormalPrice(pkgPrice);
            rtn.setSrvMemPacId(Integer.parseInt(packageInfo.get("srvMemPacId").toString()));

            if("N".equals(eurCertYn)) {
                rtn.setPackagePrice((int)Math.floor(pkgPrice));
                rtn.setHiddenNormalPrice((int)Math.floor(pkgPrice));
            } else {
                rtn.setPackagePrice(pkgPrice);
                rtn.setHiddenNormalPrice(pkgPrice);
            }

            // mNewQuotationPop.jsp :: fn_setDefaultFilterPromo
            // mNewQuotationPop.jsp :: fn_getFilterChargeList
            if(!"0".equals(param.getHiddenIsCharge().toString())) {
                if(param.getEmployee() == "1") {
                    param.setGroupCode("466");
                    param.setCodeName("FIL_MEM_DEFAULT_PROMO_EMP");
                } else {
                    param.setGroupCode("466");
                    param.setCodeName("FIL_MEM_DEFAULT_PROMO_N_EMP");
                }

                int promoId = eSVMApiMapper.getDfltPromo(eSVMApiForm.createMap(param));
                logger.debug("promoId :: " + Integer.toString(promoId));
                param.setPromoId(promoId);
                rtn.setFilterPromoId(promoId);

                logger.debug("========== getFilterChargeList_m ==========");
                logger.debug("param : {}", eSVMApiForm.createMap(param));
                rtn.setFilterCharge(this.getFilterChargeList_m(eSVMApiForm.createMap(param)));
            }
        }

        return rtn;
    }

    private int getFilterChargeList_m(Map<String, Object> param) {
        // mNewQuotationPop.jsp :: fn_getFilterChargeList
        // MembershipQuotationServiceImpl.getFilterChargeListSum
        int filterChargeSum = 0;

        eSVMApiMapper.getSVMFilterCharge(param);
        List<EgovMap> list = (List<EgovMap>) param.get("p1");

        for(EgovMap result : list) {
            double prc = Math.floor(Double.parseDouble(result.get("prc").toString()));

            if ("N".equals(param.get("zeroRatYn")) || "N".equals(param.get("eurCertYn"))) {
                filterChargeSum += Math.floor((double) (prc));
            } else {
                filterChargeSum += prc;
            }
        }

        return filterChargeSum;
    }
}
