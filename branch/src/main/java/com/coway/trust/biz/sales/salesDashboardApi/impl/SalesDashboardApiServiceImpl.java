package com.coway.trust.biz.sales.salesDashboardApi.impl;

import javax.annotation.Resource;

import org.apache.commons.collections4.MapUtils;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.sales.salesDashboardApi.SalesDashboardApiDto;
import com.coway.trust.api.mobile.sales.salesDashboardApi.SalesDashboardApiForm;
import com.coway.trust.biz.sales.salesDashboardApi.SalesDashboardApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : SalesDashboardApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 *
 *          <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 12. 23.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Service("SalesDashboardApiService")
public class SalesDashboardApiServiceImpl extends EgovAbstractServiceImpl implements SalesDashboardApiService {



    @Resource(name = "SalesDashboardApiMapper")
    private SalesDashboardApiMapper salesDashboardApiMapper;



    @Override
    public SalesDashboardApiDto selectSalesDashboard(SalesDashboardApiForm param) throws Exception {
        if (null == param) {
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }
        if (CommonUtils.isEmpty(param.getMemId())) {
            throw new ApplicationException(AppConstants.FAIL, "MemId value does not exist.");
        }
        EgovMap selectSalesDashboard = salesDashboardApiMapper.selectSalesDashboard(SalesDashboardApiForm.createMap(param));
        SalesDashboardApiDto rtn = new SalesDashboardApiDto();
        if( MapUtils.isNotEmpty(selectSalesDashboard) ){
            return rtn.create(selectSalesDashboard);
        }
        return rtn;
    }
}
