package com.coway.trust.biz.sales.expiringCustomerApi.impl;

import java.util.List;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.sales.expiringCustomerApi.ExpiringCustomerApiDto;
import com.coway.trust.api.mobile.sales.expiringCustomerApi.ExpiringCustomerApiForm;
import com.coway.trust.biz.sales.expiringCustomerApi.ExpiringCustomerApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : ExpiringCustomerApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 *
 *          <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 12. 30.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Service("ExpiringCustomerApiService")
public class ExpiringCustomerApiServiceImpl extends EgovAbstractServiceImpl implements ExpiringCustomerApiService {



    private static final Logger LOGGER = LoggerFactory.getLogger(ExpiringCustomerApiServiceImpl.class);



    @Resource(name = "ExpiringCustomerApiMapper")
    private ExpiringCustomerApiMapper expiringCustomerApiMapper;



    @Override
    public List<EgovMap> selectExpiringCustomer(ExpiringCustomerApiForm param) throws Exception {
        if (null == param) {
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }
        if (CommonUtils.isEmpty(param.getMemId())) {
            throw new ApplicationException(AppConstants.FAIL, "memId value does not exist.");
        }
        if (CommonUtils.isEmpty(param.getSrvExprMth())) {
            throw new ApplicationException(AppConstants.FAIL, "srvExprMth value does not exist.");
        }
        return expiringCustomerApiMapper.selectExpiringCustomer(ExpiringCustomerApiForm.createMap(param));
    }



    @Override
    public ExpiringCustomerApiDto selectExpiringCustomerDetail(ExpiringCustomerApiForm param) throws Exception {
        if (null == param) {
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }
        if (CommonUtils.isEmpty(param.getId())) {
            throw new ApplicationException(AppConstants.FAIL, "id value does not exist.");
        }

        EgovMap selectExpiringCustomer = expiringCustomerApiMapper.selectExpiringCustomerDetail(ExpiringCustomerApiForm.createMap(param));
        ExpiringCustomerApiDto rtn = ExpiringCustomerApiDto.create(selectExpiringCustomer);

        if (CommonUtils.isEmpty(rtn.getCustId())) {
            throw new ApplicationException(AppConstants.FAIL, "custId value does not exist.");
        }

        param.setCustId(rtn.getCustId());
        List<EgovMap> selectExpiringCustomerDetailList = expiringCustomerApiMapper.selectExpiringCustomerDetailList(ExpiringCustomerApiForm.createMap(param));
        if(LOGGER.isDebugEnabled()){
            for (int i = 0; i < selectExpiringCustomerDetailList.size(); i++) {
                LOGGER.debug("selectExpiringCustomer    값 : {}", selectExpiringCustomerDetailList.get(i));
            }
        }
        rtn.setDetailList( selectExpiringCustomerDetailList.stream().map(r -> ExpiringCustomerApiDto.create(r)).collect(Collectors.toList()) );
        return rtn;
    }
}
