package com.coway.trust.biz.sales.addressApi.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.sales.addressApi.AddressApiForm;
import com.coway.trust.biz.sales.addressApi.AddressApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : AddressApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 24.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Service("AddressApiService")
public class AddressApiServiceImpl extends EgovAbstractServiceImpl implements AddressApiService{



	@Resource(name = "AddressApiMapper")
	private AddressApiMapper addressApiMapper;



	@Override
	public List<EgovMap> selectStateCodeList(AddressApiForm param) throws Exception {
		return addressApiMapper.selectStateCodeList(AddressApiForm.createMap(param));
	}



    @Override
    public List<EgovMap> selectCityCodeList(AddressApiForm param) throws Exception {
        if(null == param){
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getState()) ){
            throw new ApplicationException(AppConstants.FAIL, "State value does not exist.");
        }
        return addressApiMapper.selectCityCodeList(AddressApiForm.createMap(param));
    }

    @Override
    public List<EgovMap> selectPostcodeList(AddressApiForm param) throws Exception {
        if(null == param){
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }
        return addressApiMapper.selectPostcodeList(AddressApiForm.createMap(param));
    }

    @Override
    public List<EgovMap> selectAreaList(AddressApiForm param) throws Exception {
        if(null == param){
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }
        return addressApiMapper.selectAreaList(AddressApiForm.createMap(param));
    }


    @Override
    public List<EgovMap> selectAddressList(AddressApiForm param) throws Exception {
        if(null == param){
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getState()) ){
            throw new ApplicationException(AppConstants.FAIL, "State value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getCity()) ){
            throw new ApplicationException(AppConstants.FAIL, "City value does not exist.");

        }
        if( CommonUtils.isNotEmpty(param.getArea()) && param.getArea().length() < 3 ){
            throw new ApplicationException(AppConstants.FAIL, "The area value must be at least 3 characters long.");
        }
        return addressApiMapper.selectAddressList(AddressApiForm.createMap(param));
    }
}
