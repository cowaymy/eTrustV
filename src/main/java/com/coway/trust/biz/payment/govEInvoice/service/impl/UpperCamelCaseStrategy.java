package com.coway.trust.biz.payment.govEInvoice.service.impl;

import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.cfg.MapperConfig;
import com.fasterxml.jackson.databind.introspect.AnnotatedField;
import com.fasterxml.jackson.databind.introspect.AnnotatedMethod;

public class UpperCamelCaseStrategy extends PropertyNamingStrategy {

    @Override
    public String nameForField(MapperConfig<?> config, AnnotatedField field, String defaultName) {
        return convertToUpperCamelCase(defaultName);
    }

    @Override
    public String nameForGetterMethod(MapperConfig<?> config, AnnotatedMethod method, String defaultName) {
        return convertToUpperCamelCase(defaultName);
    }

    @Override
    public String nameForSetterMethod(MapperConfig<?> config, AnnotatedMethod method, String defaultName) {
        return convertToUpperCamelCase(defaultName);
    }

    private String convertToUpperCamelCase(String defaultName) {
        if (defaultName == null || defaultName.isEmpty()) {
            return defaultName;
        }
        return Character.toUpperCase(defaultName.charAt(0)) + defaultName.substring(1);
    }
}