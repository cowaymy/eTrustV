package com.coway.trust.config.datasource;

import java.lang.reflect.Method;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

@Configuration
@EnableAspectJAutoProxy
@Aspect
@Component
@Order(value = 1)
public class ChangeDataSourceAspect implements InitializingBean {
	private static final Logger LOGGER = LoggerFactory.getLogger(ChangeDataSourceAspect.class);

	/**
	 * Payment - Select Retal Billing Info
	 */
	@Pointcut("execution(* com.coway.trust.biz.*..impl.CommonPaymentServiceImpl.*(..))")
	public void paymentRentalBillingInfoServiceMethod() {
		// aop pointcut
	}

	/**
	 * Payment - Create Bill
	 */
	@Pointcut("execution(* com.coway.trust.biz.*..impl.BillingMgmtServiceImpl.*(..))")
	public void paymentBillingServiceMethod() {
		// aop pointcut
	}

	/**
	 * Payment - Invoice 생성
	 */
	@Pointcut("execution(* com.coway.trust.biz.*..impl.InvoiceServiceImpl.*(..))")
	public void paymentInvoiceServiceMethod() {
		// aop pointcut
	}

	/**
	 * Payment - Service Membership Invoice 생성
	 */
	@Pointcut("execution(* com.coway.trust.biz.*..impl.SrvMembershipBillingServiceImpl.*(..))")
	public void paymentSrvMemBillingServiceMethod() {
		// aop pointcut
	}

	@Pointcut("execution(* com.coway.trust.biz.*..impl.CommissionCalculationServiceImpl.*(..))")
	public void commissionCalculationServiceMethod() {
		// aop pointcut
	}

	@Pointcut("execution(* com.coway.trust.biz.*..impl.XxxxServiceImpl.*(..))")
	public void xxxxServiceMethod() {
		// sample aop pointcut
	}

	@Before("paymentRentalBillingInfoServiceMethod() || paymentBillingServiceMethod() || paymentInvoiceServiceMethod() || paymentSrvMemBillingServiceMethod() || commissionCalculationServiceMethod() || xxxxServiceMethod()")
	public void before(JoinPoint joinPoint) throws Exception {
		final String methodName = joinPoint.getSignature().getName();
		final MethodSignature methodSignature = (MethodSignature) joinPoint.getSignature();
		Method method = methodSignature.getMethod();
		if (method.getDeclaringClass().isInterface()) {
			method = joinPoint.getTarget().getClass().getDeclaredMethod(methodName, method.getParameterTypes());
		}
		// Check DataSource Annotation.
		DataSource dataSource = method.getAnnotation(DataSource.class);
		if (dataSource != null) {
			ContextHolder.setDataSourceType(dataSource.value());
		} else {
			ContextHolder.setDataSourceType(DataSourceType.NORMAL);
		}

		LOGGER.debug("DataSource ===> " + ContextHolder.getDataSourceType());
	}

	@After("paymentRentalBillingInfoServiceMethod() || paymentBillingServiceMethod() || paymentInvoiceServiceMethod() || paymentSrvMemBillingServiceMethod() || commissionCalculationServiceMethod() || xxxxServiceMethod()")
	public void after(JoinPoint joinPoint) throws Exception {
		ContextHolder.clearDataSourceType();
	}

	@Override
	public void afterPropertiesSet() throws Exception {
		// afterPropertiesSet
	}
}
