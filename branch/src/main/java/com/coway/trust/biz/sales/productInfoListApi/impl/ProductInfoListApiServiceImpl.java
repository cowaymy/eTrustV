package com.coway.trust.biz.sales.productInfoListApi.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.api.mobile.sales.productInfoListApi.ProductInfoListApiForm;
import com.coway.trust.biz.sales.productInfoListApi.ProductInfoListApiService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : ProductInfoListApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 11. 13.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Service("ProductInfoListApiService")
public class ProductInfoListApiServiceImpl extends EgovAbstractServiceImpl implements ProductInfoListApiService{



	@Resource(name = "ProductInfoListApiMapper")
	private ProductInfoListApiMapper productInfoListApiMapper;



    @Override
    public List<EgovMap> selectCodeList() throws Exception {
        return productInfoListApiMapper.selectCodeList();
    }



	@Override
	public List<EgovMap> selectProductInfoList(ProductInfoListApiForm param) throws Exception {
		return productInfoListApiMapper.selectProductInfoList(ProductInfoListApiForm.createMap(param));
	}
}
