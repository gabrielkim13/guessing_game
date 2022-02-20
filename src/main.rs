use rand::Rng;
use std::cmp::Ordering;

const MIN: i32 = 1;
const MAX: i32 = 100;

fn main() {
    println!("Guess the number!");

    let secret_number = rand::thread_rng().gen_range(MIN..=MAX);

    let mut max = MAX;
    let mut min = MIN;
    let mut guess = (max - min) / 2;

    let mut tries = 0;

    loop {
        tries += 1;

        println!("You guessed: {}", guess);

        match guess.cmp(&secret_number) {
            Ordering::Less => {
                println!("Too small!");

                min = guess;
                guess = guess + (max - guess) / 2;
            }
            Ordering::Greater => {
                println!("Too big!");

                max = guess;
                guess = guess - (guess - min) / 2;
            }
            Ordering::Equal => {
                println!("You win!");
                break;
            }
        }
    }

    println!("You guessed correctly in {} tries. Congratulation!!!", tries);
}
