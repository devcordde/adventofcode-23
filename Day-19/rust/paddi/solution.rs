fn main() {
    let input = include_str!("./data/inputs/day_19.txt");
    println!("Part A: \x1b[1m{}\x1b[0m", part_a(input).unwrap());
    println!("Part B: \x1b[1m{}\x1b[0m", part_b(input).unwrap());
}

#[derive(Debug, Clone, PartialEq, Eq, Hash)]
struct Workflow {
    name: String,
    steps: Vec<WorkflowStep>,
}

#[derive(Debug, Clone, PartialEq, Eq, Hash)]
struct ConditionalWorkflowStep {
    category: Category,
    comparison: Comparison,
    value: u32,
    send_to_workflow: String,
}

impl WorkflowStep {
    fn get_next_workflow(&self, part: &Part) -> Option<String> {
        match self {
            WorkflowStep::Conditional(conditional) => {
                let value_to_compare = match conditional.category {
                    Category::X => part.x,
                    Category::M => part.m,
                    Category::A => part.a,
                    Category::S => part.s,
                };

                let send = if conditional.comparison == Comparison::Greater {
                    value_to_compare > conditional.value
                } else {
                    value_to_compare < conditional.value
                };

                if send {
                    Some(conditional.send_to_workflow.clone())
                } else {
                    None
                }
            }
            WorkflowStep::Unconditional(u) => Some(u.to_string()),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Hash)]
enum WorkflowStep {
    Conditional(ConditionalWorkflowStep),
    Unconditional(String),
}

#[derive(Debug, Copy, Clone, PartialEq, Eq, Hash)]
enum Comparison {
    Greater,
    Lesser,
}

#[derive(Debug, Copy, Clone, PartialEq, Eq, Hash)]
enum Category {
    X,
    M,
    A,
    S,
}

#[derive(Debug, Copy, Clone, PartialEq, Eq, Hash)]
struct Part {
    x: u32,
    m: u32,
    a: u32,
    s: u32,
}

pub fn part_a(input: &str) -> Option<u32> {
    let (workflow_string, parts_string) = input.split_once("\n\n").unwrap();

    let mut workflows = vec![];
    for workflow in workflow_string.lines() {
        let (name, rest) = workflow.split_once('{').unwrap();
        let steps = rest.strip_suffix('}').unwrap().split(',');
        let mut step_list = vec![];
        for step in steps {
            if step.contains(':') {
                let (comparison, cmp_symbol) = if step.contains('<') {
                    (Comparison::Lesser, "<")
                } else {
                    (Comparison::Greater, ">")
                };
                let (category_string, rest) = step.split_once(cmp_symbol).unwrap();
                let category = match category_string {
                    "x" => Category::X,
                    "m" => Category::M,
                    "a" => Category::A,
                    "s" => Category::S,
                    _ => unreachable!(),
                };
                let (value_string, next_workflow) = rest.split_once(':').unwrap();
                let step = ConditionalWorkflowStep {
                    category,
                    comparison,
                    value: value_string.parse().unwrap(),
                    send_to_workflow: next_workflow.to_string(),
                };

                step_list.push(WorkflowStep::Conditional(step));
            } else {
                step_list.push(WorkflowStep::Unconditional(step.to_string()));
            }
        }
        let workflow = Workflow {
            name: name.to_string(),
            steps: step_list,
        };
        workflows.push(workflow)
    }

    let mut parts = vec![];
    for part in parts_string.lines() {
        let stripped_part = part.strip_prefix('{').unwrap().strip_suffix('}').unwrap();
        let attributes = stripped_part
            .split(',')
            .map(|attr| attr.split_once('=').unwrap().1.parse().unwrap())
            .collect::<Vec<_>>();

        parts.push(Part {
            x: attributes[0],
            m: attributes[1],
            a: attributes[2],
            s: attributes[3],
        });
    }

    let mut sum = 0;
    for part in parts {
        let mut current_workflow_name = String::from("in");

        while !["A", "R"].contains(&current_workflow_name.as_str()) {
            let current_workflow = workflows
                .iter()
                .find(|w| w.name == current_workflow_name)
                .unwrap();
            current_workflow_name = current_workflow
                .steps
                .iter()
                .find_map(|step| step.get_next_workflow(&part))
                .unwrap();
        }

        if current_workflow_name == "A" {
            sum += part.x + part.m + part.a + part.s;
        }
    }

    Some(sum)
}

pub fn part_b(_input: &str) -> Option<u64> {
    None
}
