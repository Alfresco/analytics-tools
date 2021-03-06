package org.alfresco.analytics.core;

import static org.junit.Assert.*;

import java.util.Arrays;
import java.util.List;

import org.joda.time.DateTime;
import org.joda.time.LocalDate;
import org.junit.Test;

/**
 * Just exercises the distribute method
 *
 * @author Gethin James
 */
public class CalculatorTest
{

    Calculator calc = new CommonsCalculator();

    @Test(expected=NumberFormatException.class)
    public void testDistributeSameDay()
    {
        long[] distribution = calc.distributeDates(LocalDate.parse("2014-09-01"), LocalDate.parse("2014-09-01"), 5);
        assertNotNull(distribution);
    }
    
    @Test(expected=NumberFormatException.class)
    public void testDistributeLessThan()
    {
        long[] distribution = calc.distributeDates(LocalDate.parse("2014-09-01"), LocalDate.parse("2014-08-01"), 5);
        assertNotNull(distribution);        
    }    
    
    @Test
    public void testDistributeDates()
    {
        long[] distribution = calc.distributeDates(LocalDate.parse("2014-09-01"), LocalDate.parse("2014-10-01"), 15);
        assertEquals(15, distribution.length);
        
        distribution = calc.distributeDates(LocalDate.parse("2014-09-01"), LocalDate.parse("2014-09-02"), 5);
        assertEquals(5, distribution.length);
    }
    @Test
    public void testRandomTime()
    {
        DateTime start = DateTime.parse("2014-09-01");
        DateTime end = DateTime.parse("2014-10-02T23:59:59.999Z");
        for (int i = 0; i < 20; i++)
        {
            randomTimesAssertion(start, end);            
        }

    }

    private void randomTimesAssertion(DateTime start, DateTime end)
    {
        DateTime rand = calc.randomTime(start,end);
        //System.out.println(rand);
        assertTrue(rand.isAfter(start));
        assertTrue(rand.isBefore(end));
    }
    
    @Test
    public void testDistributeValues()
    {
        List<String> source = Arrays.asList("Red", "Green", "Blue");
        List<String> distribution = calc.distributeValues(source, 10);
        assertEquals(10, distribution.size());
        for (String dist : distribution)
        {
            assertTrue(source.contains(dist));
        }
        //System.out.println(distribution);
        
        source = Arrays.asList("Red");
        distribution = calc.distributeValues(source, 10);
        assertEquals(10, distribution.size());
    }

}
