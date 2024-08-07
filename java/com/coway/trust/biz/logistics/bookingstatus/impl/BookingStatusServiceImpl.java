/**
 * @author Adrian C.
 **/
package com.coway.trust.biz.logistics.bookingstatus.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.bookingstatus.BookingStatusService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("BookingStatusService")
public class BookingStatusServiceImpl implements BookingStatusService {

	private static final Logger logger = LoggerFactory.getLogger(BookingStatusServiceImpl.class);

	@Resource(name = "BookingStatusMapper")
	private BookingStatusMapper bookingStatusMapper;

	@Override
	public List<EgovMap> searchBookingStatusList(Map<String, Object> params)
	{
		// TODO Auto-generated method stub
		return bookingStatusMapper.searchBookingStatusList(params);
	}

}