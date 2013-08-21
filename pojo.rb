#!/usr/bin/ruby

if ARGV.size < 1
  puts "USAGE: ./generate_pojo.rb <infile.in>"
  exit
end

infile = ARGV[0]

vars = {}

def camelize(name)
  name[0].capitalize + name[1..-1]
end

File.open(infile).each_line do |line|
  type, var = line.split(' ')
  vars[var] = type
end

vars.each do |var, type|
  puts "    private #{type} #{var};\n\n"
end

vars.each do |var, type|
  puts "    public #{type} get#{camelize(var)}() {"
  puts "        return #{var};"
  puts "    }"
  puts ""
  puts "    public void set#{camelize(var)}(#{type} #{var}) {"
  puts "        this.#{var} = #{var};"
  puts "    }\n\n"  
end

puts <<EOF
    @Override
    public int hashCode() {
        return new HashCodeBuilder()
EOF

vars.each_key do |var|
  puts "            .append(#{var})" unless var == 'id'
end

puts <<EOF
        .toHashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        Widget other = (Widget) obj;
        return new EqualsBuilder()
EOF

vars.each_key do |var|
  puts "            .append(#{var}, other.get#{camelize(var)}())"
end

puts <<EOF
            .isEquals();
    }
    
    @Override
    public String toString() {
        return new ToStringBuilder(this)
EOF

vars.each_key do |var|
  puts "            .append(\"#{var}\", #{var})"
end

puts <<EOF
            .toString();
    }
EOF
