package com.coway.trust.biz.sales.orderList.impl;

import java.util.List;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.sales.orderList.OrderListApiDto;
import com.coway.trust.api.mobile.sales.orderList.OrderListApiForm;
import com.coway.trust.biz.sales.orderList.OrderListApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @ClassName : OrderListApiServiceImpl.java
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
@Service("OrderListApiService")
public class OrderListApiServiceImpl extends EgovAbstractServiceImpl implements OrderListApiService {



    @Resource(name = "OrderListApiMapper")
    private OrderListApiMapper orderListApiMapper;



    @Override
    public List<OrderListApiDto> selectOrderList(OrderListApiForm param) throws Exception {
        if (null == param) {
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }
        if (CommonUtils.isEmpty(param.getSalesDtFrom()) || CommonUtils.isEmpty(param.getSalesDtTo())) {
            throw new ApplicationException(AppConstants.FAIL, "Sales Date value does not exist.");
        }
        if (CommonUtils.isEmpty(param.getSelectType()) ) {
            throw new ApplicationException(AppConstants.FAIL, "Select type value does not exist.");
        }
        if (CommonUtils.isNotEmpty(param.getSelectType()) && param.getSelectType().equals("2") && param.getSelectKeyword().length() < 5) {
            throw new ApplicationException(AppConstants.FAIL, "Please enter at least 5 characters.");
        }
        if (CommonUtils.isEmpty(param.getMemId()) || param.getMemId() <= 0 ) {
            throw new ApplicationException(AppConstants.FAIL, "memId value does not exist.");
        }
        return orderListApiMapper.selectOrderList(OrderListApiForm.createMap(param)).stream().map(r -> OrderListApiDto.create(r)).collect(Collectors.toList());
    }
}
