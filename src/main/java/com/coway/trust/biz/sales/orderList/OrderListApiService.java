package com.coway.trust.biz.sales.orderList;

import java.util.List;
import com.coway.trust.api.mobile.sales.orderList.OrderListApiDto;
import com.coway.trust.api.mobile.sales.orderList.OrderListApiForm;

/**
 * @ClassName : OrderListApiService.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 12. 23.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
public interface OrderListApiService {



    List<OrderListApiDto> selectOrderList(OrderListApiForm param) throws Exception;
}
