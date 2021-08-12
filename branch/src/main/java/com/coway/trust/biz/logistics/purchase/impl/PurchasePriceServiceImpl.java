package com.coway.trust.biz.logistics.purchase.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.purchase.PurchasePriceService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("purchasPriceService")
public class PurchasePriceServiceImpl implements PurchasePriceService {

	@Resource(name = "purchasePriceMapper")
	private PurchasePriceMapper purchasePriceMapper;

	@Override
	public List<EgovMap> purchasePriceList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return purchasePriceMapper.purchasePriceList(params);
	}

}
